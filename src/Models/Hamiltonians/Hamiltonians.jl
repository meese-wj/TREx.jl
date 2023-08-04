module Hamiltonians

using Reexport

export AbstractHamiltonian,
       AbstractDoF, location, value

abstract type AbstractHamiltonian end

"""
    abstract type AbstractDoF end

Parent type for all _degrees of freedom_ used in the simulations.

The required interface for all DoF types is the following:

* `location`: Defines the in-memory identification for where the DoF is.
* `value`: Defines what the value of the DoF is (its current state).
"""
abstract type AbstractDoF end

location(dof::AbstractDoF) = throw(ArgumentError("A location for $(dof |> typeof) has yet to be defined."))
value(dof::AbstractDoF) = throw(ArgumentError("A value for $(dof |> typeof) has yet to be defined."))

include("SpinHamiltonians/SpinHamiltonians.jl")
@reexport using .SpinHamiltonians

end # Hamiltonians