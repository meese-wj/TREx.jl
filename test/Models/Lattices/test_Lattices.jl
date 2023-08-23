using Test
using TRExMC

@info "↳ Testing Lattices.jl"
@testset "Lattices.jl" begin

    @testset "AbstractLattice" begin
        struct FakeLattice <: Lattices.AbstractLattice end

        @test_throws MethodError Lattices.construct_lattice!(FakeLattice())
        @test_throws MethodError Lattices.num_sites(FakeLattice())
        @test_throws MethodError Lattices.site_index(FakeLattice(), 1)
        @test_throws MethodError Lattices.nearest_neighbors(FakeLattice(), 1)
        @test_throws MethodError Lattices.parameters(FakeLattice())
    end

    include("test_CubicLattices.jl")
end