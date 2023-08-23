using Test
using TRExMC

@info "↳ Testing Observables" 
@testset "Observables.jl" begin
    
    @testset "AbstractObservables" begin
        struct FakeObservable <: Observables.AbstractObservables end
        @test_throws ArgumentError measure!(FakeObservable()) 
        @test_throws ArgumentError measure!(FakeObservable(), 1) 
        @test_throws ArgumentError measure!(FakeObservable(), 1, 2) 
    end

    @testset "NullObservable" begin
        @test measure!(Observables.NullObservable()) isa Nothing
        @test measure!(Observables.NullObservable(), 1) isa Nothing
        @test measure!(Observables.NullObservable(), 1, 2) isa Nothing
    end

    @testset "@observables" begin
        
        @testset "Checks" begin
            # check mismatched sizes
            @test_throws AssertionError Observables._observables("Blah", [:A, :B], [zero])
            @test_throws AssertionError Observables._observables(:Blah, [:A], [zero, oneunit])

            # check non function arguments
            @test_throws AssertionError Observables._observables(:Blah, [:A], ["zero"])
            @test_throws AssertionError Observables._observables("Blah", [:A, :B, :C], [zero, zero, "zero"])
            
            # check non function arguments with a dictionary
            @test_throws AssertionError Observables._observables("Blah", Dict(:A => 1, :B => zero))
            @test_throws AssertionError Observables._observables(:Blah, Dict(:A => zero, :B => zero, :C => "zero"))

            # checks pass
            @test Observables._check_functions([:A], [zero]) isa Nothing
            @test Observables._check_functions([:A, :B, :C], [zero, oneunit, sqrt]) isa Nothing
        end

        @testset "_build_struct" begin
            ex1 = Observables._build_struct(:Blah, [:A])
            ex3 = Observables._build_struct(:Blah, [:A, :B, :C])
            actual1 = quote
                mutable struct Blah{T <: Number} <: Observables.AbstractObservables
                    step::Int
                    A::Vector{T}
                end
            end |> Base.remove_linenums!
            actual3 = quote
                mutable struct Blah{T <: Number} <: Observables.AbstractObservables
                    step::Int
                    A::Vector{T}
                    B::Vector{T}
                    C::Vector{T}
                end
            end |> Base.remove_linenums!
            @test ex1 == actual1
            @test ex3 == actual3
            @test ex1 != actual3
        end

        @testset "_build_constructor" begin
            ex1 = Observables._build_constructor(:Blah, [:A])
            ex3 = Observables._build_constructor(:Blah, [:A, :B, :C])
            actual1 = quote
                function Blah(::Type{T}, num_measures::Integer) where T
                    arrays = [zeros(T, num_measures) for _ ∈ range(1, 1)]
                    return Blah{T}(oneunit(Int), arrays...)
                end
            end |> Base.remove_linenums!
            actual3 = quote
                function Blah(::Type{T}, num_measures::Integer) where T
                    arrays = [zeros(T, num_measures) for _ ∈ range(1, 3)]
                    return Blah{T}(oneunit(Int), arrays...)
                end
            end |> Base.remove_linenums!
            @test ex1 == actual1
            @test ex3 == actual3
            @test ex1 != actual3
        end

        @testset "_build_measurements" begin
            symbs1 = [:A]
            funcs1 = [zero]
            symbs3 = [:A, :B, :C]
            funcs3 = [zero, oneunit, zero]
            
            @testset "_build_measurement_loop" begin
                ex1 = Observables._build_measurement_loop(symbs1, funcs1)    
                ex3 = Observables._build_measurement_loop(symbs3, funcs3)    
                actual1 = quote
                    obs.$(symbs1[1])[obs.step] = $(funcs1[1])(ham, latt)
                end |> Base.remove_linenums!
                actual3 = quote
                    obs.$(symbs3[1])[obs.step] = $(funcs3[1])(ham, latt)
                    obs.$(symbs3[2])[obs.step] = $(funcs3[2])(ham, latt)
                    obs.$(symbs3[3])[obs.step] = $(funcs3[3])(ham, latt)
                end |> Base.remove_linenums!
                @test ex1 == actual1
                @test ex3 == actual3
                @test ex1 != actual3
            end

            ex1 = Observables._build_measurements(:Blah, symbs1, funcs1)
            ex3 = Observables._build_measurements(:Blah, symbs3, funcs3)

            actual1 = quote
                function measure!(obs::Blah, ham, latt)
                    $( Observables._build_measurement_loop(symbs1, funcs1).args... )
                    obs.step += oneunit(obs.step)
                end
            end |> Base.remove_linenums!
            actual3 = quote
                function measure!(obs::Blah, ham, latt)
                    $( Observables._build_measurement_loop(symbs3, funcs3).args... )
                    obs.step += oneunit(obs.step)
                end
            end |> Base.remove_linenums!
            @test ex1 == actual1
            @test ex3 == actual3
            @test ex1 != actual3
        end

        @testset "_observables" begin
            symbs1 = [:A]
            funcs1 = [zero]
            symbs3 = [:A, :B, :C]
            funcs3 = [zero, oneunit, zero]

            ex1 = Observables._observables(:Blah, symbs1, funcs1)
            ex12 = Observables._observables("Blah", symbs1, funcs1)
            ex13 = Observables._observables("Blah", Dict(zip(symbs1, funcs1)))
            @test ex1 == ex12
            @test ex1 == ex13
            actual1 = quote
                import .Observables: measure!
                $(Observables._build_struct(:Blah, symbs1).args...)
                $(Observables._build_constructor(:Blah, symbs1).args...)
                $(Observables._build_measurements(:Blah, symbs1, funcs1).args...)
                export measure!, Blah
            end |> Base.remove_linenums!
            @test ex1 == actual1
            @test ex12 == actual1
            @test ex13 == actual1
            
            ex3 = Observables._observables(:Blah, symbs3, funcs3)
            ex32 = Observables._observables("Blah", symbs3, funcs3)
            ex33 = Observables._observables("Blah", Dict(zip(symbs3, funcs3)))
            @test ex3 == ex32
            @test ex3 == ex33
            actual3 = quote
                import .Observables: measure!
                $(Observables._build_struct(:Blah, symbs3).args...)
                $(Observables._build_constructor(:Blah, symbs3).args...)
                $(Observables._build_measurements(:Blah, symbs3, funcs3).args...)
                export measure!, Blah
            end |> Base.remove_linenums!
            @test ex3 == actual3
            @test ex32 == actual3
            @test ex33 == actual3
        end

    end

end