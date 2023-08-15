module Models

using ..Parameters

include("Lattices/Lattices.jl")
using .Lattices
export Lattices

include("Hamiltonians/Hamiltonians.jl")
using .Hamiltonians
import .Hamiltonians: hamiltonian
export Hamiltonians

include("Observables/Observables.jl")
using .Observables
import .Observables: measure!
export Observables

export Model, lattice, hamiltonian, observables, measure!

"""
    Model{L, H[, O]}

The main container used for simulations. The type parameters are given by

* `L <: `[`AbstractLattice`](@ref)
* `H <: `[`AbstractHamiltonian`](@ref)
* `O <: `[`AbstractObservable`](@ref)
    * If no observable is provided, then the [`NullObservable`](@ref) is used.
"""
struct Model{L <: AbstractLattice, H <: AbstractHamiltonian, O <: AbstractObservables}
    latt::L
    ham::H
    obs::O
end
Model(latt, ham) = Model(latt, ham, NullObservable())

"""
    lattice(::Model)

Convenience function to access the `<: `[`AbstractLattice`](@ref) of a [`Model`](@ref).
"""
lattice(m::Model) = m.latt

"""
    hamiltonian(::Model)

Convenience function to access the `<: `[`AbstractHamiltonian`](@ref) of a [`Model`](@ref).
"""
hamiltonian(m::Model) = m.ham

"""
    observables(::Model)

Convenience function to access the `<: `[`AbstractObservables`](@ref) of a [`Model`](@ref).
"""
observables(m::Model) = m.obs
"""
    measure!(m::Model)

Convenience function to take measurements in a [`Model`](@ref).
"""
measure!(m::Model) = measure!(observables(m), hamiltonian(m), lattice(m))

end