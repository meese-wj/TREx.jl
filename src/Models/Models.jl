module Models

# Use this to reexport the namespaces from each submodule
using Reexport

include("Lattices/Lattices.jl")
@reexport using .Lattices

include("Hamiltonians/Hamiltonians.jl")
@reexport using .Hamiltonians

include("Observables/Observables.jl")
@reexport using .Observables

end