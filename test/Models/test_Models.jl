using Test
using TREx

@info "TREx/Models.jl"
@testset "Models.jl" begin
    include("Lattices/test_Lattices.jl")
    include("Hamiltonians/test_Hamiltonians.jl")
end