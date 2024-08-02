"""
# `TRExMC`: Thermodynamics via Replica-Exchange Monte Carlo
"""
module TRExMC

# Use this to reexport the namespaces from each submodule
using Reexport

include("Parameters/Parameters.jl")
import .Parameters: thermalization_sweeps, measurement_sweeps
export Parameters
export thermalization_sweeps, measurement_sweeps

include("Models/Models.jl")
@reexport using .Models  # have direct access to Models/submodules

include("Algorithms/Algorithms.jl")
@reexport using .Algorithms # have direct access to all Algorithms

include("Simulations/Simulations.jl")
export Simulations

end
