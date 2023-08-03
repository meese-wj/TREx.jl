using TREx
using Test

@testset "TREx.jl" begin

    include("Parameters/test_Parameters.jl")
    include("Models/test_Models.jl")
    include("Simulations/test_Simulations.jl")

end
