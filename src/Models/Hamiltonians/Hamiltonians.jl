module Hamiltonians

using Reexport
using ..Parameters

export AbstractHamiltonian,
       AbstractDoF, location, value,
       energy, DoF_energy

"""
    abstract type AbstractHamiltonian end

Parent type for all Hamiltonians in the simulation.

The required interface that all Hamiltonians must satisfy are 
specified by the following functions:

* `DoF`: the [`AbstractDoF`](@ref) stored at a given memory location
* `energy`: total energy of the Hamiltonian
* `DoF_energy`: energy associated with a single [`AbstractDoF`](@ref)
"""
abstract type AbstractHamiltonian end

DoF(ham::AbstractHamiltonian, location, args...) = throw(ArgumentError("DoF for $(ham |> typeof) at location $(location)::$(location |> typeof) has yet to be defined."))
energy(ham::AbstractHamiltonian, args...) = throw(ArgumentError("Energy for $(ham |> typeof) types has yet to be defined."))
DoF_energy(ham::AbstractHamiltonian, args...) = throw(ArgumentError("Energy for $(ham |> typeof) types has yet to be defined."))
num_DoF(ham::AbstractHamiltonian, args...) = throw(ArgumentError("No number of DoFs has been defined for $(ham |> typeof) types."))

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

include("HamiltonianIterators.jl")

include("SpinHamiltonians/SpinHamiltonians.jl")
@reexport using .SpinHamiltonians

end # Hamiltonians