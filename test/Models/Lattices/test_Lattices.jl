using Test
using TRExMC

@info "↳ Testing Lattices.jl"
@testset "Lattices.jl" begin
    include("test_CubicLattices.jl")
end