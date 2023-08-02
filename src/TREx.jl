module TREx

# Use this to reexport the namespaces from each submodule
using Reexport

include("Parameters/Parameters.jl")
import .Parameters: thermalization_sweeps, measurement_sweeps
export Parameters
export thermalization_sweeps, measurement_sweeps

include("Models/Models.jl")
@reexport using .Models  # have direct access to Models/submodules

include("Simulations/Simulations.jl")
export Simulations

end
