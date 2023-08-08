using Test
using TRExMC

@info " ↳ Testing SpinHamiltonians"
@testset "SpinHamiltonians.jl" begin
    
    include("test_Ising.jl")

end