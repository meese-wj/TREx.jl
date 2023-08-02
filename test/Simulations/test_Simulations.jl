using Test
using TREx

@testset "TREx/Simulations.jl" begin 

    @testset "Procedures" begin 
        struct test_params
            therm_sweeps::Int
            mc_sweeps::Int
        end

        test_p = test_params(10, 100)
        @test Simulations.total_sweeps(Simulations.Thermalization(), test_p) == 10
        @test Simulations.total_sweeps(Simulations.MonteCarloSimulation(), test_p) == 100

        struct FakeProcedure <: Simulations.AbstractMCProcedure end
        @test_throws ArgumentError Simulations.total_sweeps(FakeProcedure(), 1.0)
        @test_throws ArgumentError Simulations.total_sweeps(FakeProcedure(), test_p)
    end

end