using Test
using TRExMC

@info "TRExMC/Simulations.jl"
@testset "TRExMC/Simulations.jl" begin 

    @testset "Procedures" begin 
        let 
            struct test_params <: Parameters.SimulationParameters
                therm_sweeps::Int
                mc_sweeps::Int
            end

            TRExMC.thermalization_sweeps(p::test_params) = p.therm_sweeps
            TRExMC.measurement_sweeps(p::test_params) = p.mc_sweeps

            test_p = test_params(10, 100)
            @test Simulations.total_sweeps(Simulations.Thermalization(), test_p) == 10
            @test Simulations.total_sweeps(Simulations.MonteCarloSimulation(), test_p) == 100

            struct FakeProcedure <: Simulations.AbstractMCProcedure end
            @test_throws ArgumentError Simulations.total_sweeps(FakeProcedure(), test_p)
        end 
    end

end