module Models

using Random

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
import .Observables: measure!, @observables
export Observables, @observables

export AbstractModel, Model, rng, lattice, hamiltonian, observables, measure!

abstract type AbstractModel end
rng(m::AbstractModel) = throw(MethodError(rng, m))
lattice(m::AbstractModel) = throw(MethodError(lattice, m))
hamiltonian(m::AbstractModel) = throw(MethodError(hamiltonian, m))
observables(m::AbstractModel) = throw(MethodError(observables, m))
measure!(m::AbstractModel) = throw(MethodError(measure!, m))

# TODO: Maybe just make this structure Abstract? 
#       Just assume that all model subtypes will have
#       this struct layout? Easier to dispatch iteration
#       schemes then...
"""
    Model{L, H[, O]}

The main container used for simulations. The type parameters are given by

* `R <: Random.AbstractRNG`
* `L <: `[`AbstractLattice`](@ref)
* `H <: `[`AbstractHamiltonian`](@ref)
* `O <: `[`AbstractObservable`](@ref)
    * If no observable is provided, then the [`NullObservable`](@ref) is used.
"""
struct Model{R <: Random.AbstractRNG, L <: AbstractLattice, H <: AbstractHamiltonian, O <: AbstractObservables} <: AbstractModel
    rng::R
    latt::L
    ham::H
    obs::O
end
Model(latt::AbstractLattice, args...) = Model(Random.GLOBAL_RNG, latt, args...)
Model(rng::Random.AbstractRNG, latt, ham) = Model(rng, latt, ham, NullObservable())
Model(latt::AbstractLattice, ham) = Model(latt, ham, NullObservable())

"""
    rng(::Model)

Convenience function to access the Random Number Generator a [`Model`](@ref).
"""
rng(m::Model) = m.rng
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

include("HamiltonianWrappers.jl")

end