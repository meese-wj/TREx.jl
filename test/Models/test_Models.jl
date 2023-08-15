using Test
using TRExMC

@info "TRExMC/Models.jl"
@testset "Models.jl" begin
    include("Lattices/test_Lattices.jl")
    include("Hamiltonians/test_Hamiltonians.jl")
    include("Observables/test_Observables.jl")
end