using Test
using TREx

@testset "TREx/Parameters.jl" begin
    
    @testset "Type Hierarchy" begin
        let 
            struct TestSimParams <: Parameters.SimulationParameters end
            
            TREx.thermalization_sweeps(p::TestSimParams) = 2
            TREx.measurement_sweeps(p::TestSimParams) = 4

            @test TREx.thermalization_sweeps(TestSimParams()) == 2
            @test TREx.measurement_sweeps(TestSimParams()) == 4

            struct FakeSimParams <: Parameters.SimulationParameters end

            @test_throws ArgumentError TREx.thermalization_sweeps(FakeSimParams())
            @test_throws ArgumentError TREx.measurement_sweeps(FakeSimParams())

            struct FakeModelParams <: Parameters.ModelParameters end

            @test_throws MethodError TREx.thermalization_sweeps(FakeModelParams())
            @test_throws MethodError TREx.measurement_sweeps(FakeModelParams())
        end
    end

end