using Test
using TRExMC

@info "↳ Testing Hamiltonians"
@testset "Hamiltonians.jl" begin

    @testset "Testing AbstractHamiltonian" begin
        struct FakeHam <: Hamiltonians.AbstractHamiltonian end
        
        @test_throws ArgumentError Hamiltonians.DoF(FakeHam(), 1)
        @test_throws ArgumentError Hamiltonians.DoF(FakeHam(), 1, 42) # test args...
        
        @test_throws ArgumentError Hamiltonians.energy(FakeHam())
        @test_throws ArgumentError Hamiltonians.energy(FakeHam(), 42) # test args...

        @test_throws ArgumentError Hamiltonians.DoF_energy(FakeHam())
        @test_throws ArgumentError Hamiltonians.DoF_energy(FakeHam(), 42) # test args...
        
        @test_throws ArgumentError Hamiltonians.num_DoF(FakeHam())
        @test_throws ArgumentError Hamiltonians.num_DoF(FakeHam(), 42) # test args...
    end

    @testset "Testing AbstractDoF" begin
        struct FakeDoF <: Hamiltonians.AbstractDoF end
        @test_throws ArgumentError Hamiltonians.location(FakeDoF())        
        @test_throws ArgumentError Hamiltonians.value(FakeDoF())        
    end

    include("SpinHamiltonians/test_SpinHamiltonians.jl")

end