using TRExMC
using Test

@testset "TRExMC.jl" begin

    include("Parameters/test_Parameters.jl")
    include("Models/test_Models.jl")
    include("Simulations/test_Simulations.jl")

end
