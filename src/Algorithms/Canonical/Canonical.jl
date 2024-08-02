module Canonical

using ..Algorithms
import .Algorithms.Models
# import ..Algorithms: iterate_DoFs, DoF_location, DoF_value, current_state, proposed_state, DoF_energy_change
@show names(Algorithms)
@show names(Models)

include("Metropolis.jl")

end # Canonical