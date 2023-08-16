using Test
using TRExMC

@info "TRExMC/Algorithms.jl"
@testset "Algorithms.jl" begin

    @testset "AbstractAlgorithm" begin
        struct FakeAlg <: Algorithms.AbstractAlgorithm end
        @test_throws ArgumentError procedure(FakeAlg())
    end
    
    @testset "@algorithm" begin
        
        @testset "_check_func" begin
            @test_throws ArgumentError Algorithms._check_func("Hi", 1, 3)
            @test_throws ArgumentError Algorithms._check_func("Hi", 1, nothing)
            @test_throws ArgumentError Algorithms._check_func("Hi", 1, :String)
        end

        @testset "_define_procedure" begin
            name = "HelloThere"
            name_S = Symbol(name)
            func = println
            
            # export_alg = false
            expr = Algorithms._define_procedure(false, name, func)
            actual = quote
                import .Algorithms: procedure
                procedure(::$(name_S)) = Algorithms._algorithm_setup(false, $name_S, $func) |> Base.remove_linenums! 
            end |> Base.remove_linenums!
            @test expr == actual
            
            # export_alg = true
            expr = Algorithms._define_procedure(true, name, func)
            actual = quote
                import .Algorithms: procedure
                procedure(::$(name_S)) = Algorithms._algorithm_setup(true, $name_S, $func) |> Base.remove_linenums! 
                export procedure
            end |> Base.remove_linenums!
            @test expr == actual
        end

        @testset "_struct_setup" begin
            name = :TonyStark
            ex1 = Algorithms._struct_setup(name)
            @test ex1 == ( :( struct $name <: Algorithms.AbstractAlgorithm end ) |> Base.remove_linenums! )
            
            name = "TonyStark"
            ex2 = Algorithms._struct_setup(name)
            @test ex2 == ( :( struct $(name |> Symbol) <: Algorithms.AbstractAlgorithm end ) |> Base.remove_linenums! ) 
            @test ex1 == ex2
        end

        @testset "_body_setup" begin
            name = :CincoDeMayo
            fxns = [println, show]
            ex1 = Algorithms._body_setup(name, fxns...)
            actual = quote
                Algorithms._check_func($name, 1, $(fxns[1]))
                $(fxns[1])(m, args...)
                Algorithms._check_func($name, 2, $(fxns[2]))
                $(fxns[2])(m, args...)
            end |> Base.remove_linenums!
            @test ex1 == actual
        end
        
        @testset "_constructor_overload" begin
            name = "HowdyYall"
            name_S = Symbol(name)
            fxns = [println, show, display]

            ex1 = Algorithms._constructor_overload(name, fxns...)
            actual = quote
                function $name_S(m::AbstractModel, args...)
                    $(Algorithms._body_setup(name, fxns...))
                    return m
                end
            end |> Base.remove_linenums!
            @test ex1 == actual
            ex2 = Algorithms._constructor_overload(name_S, fxns...)
            @test ex2 == actual
            @test ex1 == ex2
        end

        @testset "_algorithm_setup" begin
            name = "HowdyYall"
            name_S = Symbol(name)
            fxns = [println, show, display]

            # export_alg = false
            ex1 = Algorithms._algorithm_setup(false, name, fxns...)
            ex2 = Algorithms._algorithm_setup(false, name_S, fxns...)
            actual = quote
                $(Algorithms._struct_setup(name))
                $(Algorithms._constructor_overload(name, fxns...))
            end |> Base.remove_linenums! 
            @test ex1 == actual
            @test ex2 == actual
            @test ex1 == ex2
            
            # export_alg = true
            ex1 = Algorithms._algorithm_setup(true, name, fxns...)
            ex2 = Algorithms._algorithm_setup(true, name_S, fxns...)
            push!(actual.args, :(export $name_S))
            actual = actual |> Base.remove_linenums! 
            @test ex1 == actual
            @test ex2 == actual
            @test ex1 == ex2
        end

        @testset "_algorithm" begin
            name = "PhysicsIsCool"
            fxns = [push!, append!, show, println, display]

            # export_alg = false
            ex1 = Algorithms._algorithm(false, name, fxns...)
            ex2 = Algorithms._algorithm(false, name |> Symbol, fxns...)
            actual = Expr(:block)
            actual2 = Expr(:block)
            append!(actual.args, Algorithms._algorithm_setup(false, name, fxns...).args)
            append!(actual.args, Algorithms._define_procedure(false, name, fxns...).args)
            push!(actual.args, :(methods($(name |> Symbol))))
            actual = actual |> Base.remove_linenums!
            @test ex1 == actual
            @test ex2 == actual
            @test ex1 == ex2
        end
    end

end