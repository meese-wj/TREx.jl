using Test
using TRExMC
using Random 

@info " ↳ Testing Iterators..."
@testset "HamiltonianIterators.jl" begin
    
    @testset "Iterator Interface" begin
        struct FakeIter <: Hamiltonians.AbstractHamiltonianIterator end

        @test_throws ErrorException Hamiltonians.hamiltonian(FakeIter())
        @test_throws ErrorException Hamiltonians.DoF(FakeIter(), 1)
        @test_throws ArgumentError iterate(FakeIter())
    end

    @testset "Basic Iterator Usage" begin
        
        struct TestHamIter <: Hamiltonians.AbstractHamiltonian
            values::Vector{Int}
        end
        Hamiltonians.DoF(ham::TestHamIter, loc) = ham.values[loc]
        Hamiltonians.num_DoF(ham::TestHamIter) = length(ham.values)

        vals = TestHamIter(1:5)
        @test Hamiltonians.DoF(vals, 2) == 2
        @test Hamiltonians.num_DoF(vals) == 5

        @testset "IterateByLocation" begin
            @test Hamiltonians.num_DoF(Hamiltonians.IterateByLocation(vals)) == Hamiltonians.num_DoF(vals)
            @test all( Hamiltonians.iterate(Hamiltonians.IterateByLocation(vals)) .== (1, 2) ) 
            @test Hamiltonians.iterate(Hamiltonians.IterateByLocation(vals), (5, 6)) isa Nothing 

            iterated_vals = []
            for iter in Hamiltonians.IterateByLocation(vals)
                push!(iterated_vals, iter)
            end
            @test all(iterated_vals .== vals.values)
        end
        
        @testset "IterateAtRandom" begin
            rand_range = 1:1000
            vals = TestHamIter(rand_range)
            rng = Xoshiro(42)

            @test Hamiltonians.num_DoF(Hamiltonians.IterateAtRandom(vals)) == Hamiltonians.num_DoF(vals)
            @test Hamiltonians.iterate(Hamiltonians.IterateAtRandom(vals), (5, length(rand_range) + 1)) isa Nothing 

            iterated_indices = []
            iterated_values = []
            for (iter, val) in enumerate( Hamiltonians.IterateAtRandom(rng, vals) )
                push!(iterated_indices, iter)
                push!(iterated_values, val)
            end
            unique_vals = unique(iterated_values)

            @test length(iterated_indices) == Hamiltonians.num_DoF(vals)
            @test length(iterated_values) == Hamiltonians.num_DoF(vals)
            @test minimum(rand_range) ≤ minimum(unique_vals)
            @test maximum(rand_range) ≥ maximum(unique_vals)
            @test all(iterated_indices .== vals.values)
        end

    end

end