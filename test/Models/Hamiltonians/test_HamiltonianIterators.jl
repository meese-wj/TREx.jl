using Test
using TRExMC

@info " ↳ Testing Iterators..."
@testset "HamiltonianIterators.jl" begin
    
    @testset "Iterator Interface" begin
        struct FakeIter <: Hamiltonians.AbstractHamiltonianIterator end

        @test_throws ErrorException Hamiltonians.hamiltonian(FakeIter())
        @test_throws ErrorException Hamiltonians.DoF(FakeIter(), 1)
        @test_throws ArgumentError iterate(FakeIter())
    end

end