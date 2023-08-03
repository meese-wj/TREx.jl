using Test
using TREx

@info "↳ Testing Lattices.jl"
@testset "Lattices.jl" begin
    include("test_CubicLattices.jl")
end