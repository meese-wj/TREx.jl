using Test
using TRExMC

@info "TRExMC/Parameters.jl"
@testset "TRExMC/Parameters.jl" begin
    
    @testset "Type Hierarchy" begin
        let 
            struct TestSimParams <: Parameters.SimulationParameters end
            
            TRExMC.thermalization_sweeps(p::TestSimParams) = 2
            TRExMC.measurement_sweeps(p::TestSimParams) = 4

            @test thermalization_sweeps(TestSimParams()) == 2
            @test measurement_sweeps(TestSimParams()) == 4

            struct FakeSimParams <: Parameters.SimulationParameters end

            @test_throws ArgumentError thermalization_sweeps(FakeSimParams())
            @test_throws ArgumentError measurement_sweeps(FakeSimParams())

            struct FakeModelParams <: Parameters.ModelParameters end

            @test_throws MethodError thermalization_sweeps(FakeModelParams())
            @test_throws MethodError measurement_sweeps(FakeModelParams())
        end
    end

    @testset "MetropolisParameters" begin
        p = Parameters.MetropolisParameters(; therm_sweeps = 24, mc_sweeps = 42)

        @test thermalization_sweeps(p) == 24
        @test measurement_sweeps(p) == 42

        @test_throws MethodError Parameters.MetropolisParameters(; therm_sweeps = "hi")
        @test_throws MethodError Parameters.MetropolisParameters(; mc_sweeps = "hi")
        @test_throws MethodError Parameters.MetropolisParameters(; temperatures = "hi")
    end

end