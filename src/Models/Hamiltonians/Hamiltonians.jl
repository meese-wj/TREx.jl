module Hamiltonians

using Reexport
using ..Parameters
using ..Lattices

export AbstractHamiltonian,
       AbstractDoF, DoF_location, DoF_value,
       DoF, energy, DoF_energy, num_DoF

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

DoF(::ham_t, location, args...) where ham_t <: AbstractHamiltonian = throw(ArgumentError("DoF for $ham_t at location $(location)::$(location |> typeof) has yet to be defined."))
energy(::ham_t, args...) where ham_t <: AbstractHamiltonian = throw(ArgumentError("Energy for $ham_t types has yet to be defined."))
DoF_energy(::ham_t, args...) where ham_t <: AbstractHamiltonian = throw(ArgumentError("Energy for $ham_t types has yet to be defined."))
num_DoF(::ham_t, args...) where ham_t <: AbstractHamiltonian = throw(ArgumentError("No number of DoFs has been defined for $ham_t types."))

"""
    abstract type AbstractDoF end

Parent type for all _degrees of freedom_ used in the simulations.

The required interface for all DoF types is the following:

* `DoF_location`: Defines the in-memory identification for where the DoF is.
* `DoF_value`: Defines what the value of the DoF is (its current state).
"""
abstract type AbstractDoF end

DoF_location(::dof_t) where dof_t <: AbstractDoF = throw(ArgumentError("A location for $dof_t has yet to be defined."))
DoF_value(::dof_t) where dof_t <: AbstractDoF = throw(ArgumentError("A value for $dof_t has yet to be defined."))

include("HamiltonianIterators.jl")

include("SpinHamiltonians/SpinHamiltonians.jl")
@reexport using .SpinHamiltonians

end # Hamiltonians