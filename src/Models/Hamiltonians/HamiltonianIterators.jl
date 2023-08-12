
using Base
using Random

export iterate, hamiltonian, IterateByLocation, IterateAtRandom

"""
    abstract type AbstractHamiltonianIterator end

Iterface for iteration through a given Hamiltonian.
"""
abstract type AbstractHamiltonianIterator end
hamiltonian(itr::AbstractHamiltonianIterator) = itr.ham
num_DoF(itr::AbstractHamiltonianIterator) = (num_DoF ∘ hamiltonian)(itr)
DoF(itr::AbstractHamiltonianIterator, location) = DoF(itr |> hamiltonian, location)  

Base.iterate(::itr_t, args...) where itr_t <: AbstractHamiltonianIterator = throw(ArgumentError("No iteration technique has been defined for $itr_t types."))

struct IterateByLocation{H <: AbstractHamiltonian} <: AbstractHamiltonianIterator
    ham::H
end
struct IterateAtRandom{RNG <: AbstractRNG, H <: AbstractHamiltonian} <: AbstractHamiltonianIterator
    rng::RNG
    ham::H
end

IterateAtRandom(ham) = IterateAtRandom(Random.GLOBAL_RNG, ham)

_random_location(itr) = rand(itr.rng, 1:num_DoF(itr))

_iter_done(itr, current_itr) = current_itr > num_DoF(itr)

function Base.iterate(itr::IterateByLocation, DoFstate = (DoF(itr, 1), 1))
    current_itr = DoFstate[end]
    if _iter_done(itr, current_itr)
        return nothing
    end
    next_itr = current_itr + 1
    return (DoF(itr, current_itr), next_itr)
end

function Base.iterate(itr::IterateAtRandom, DoFstate = (DoF(itr, _random_location(itr)), 1) )
    current_itr = DoFstate[end]
    if _iter_done(itr, current_itr)
        return nothing
    end
    next_itr = current_itr + 1
    randloc = _random_location(itr)
    return ( DoF(itr, randloc), next_itr )
end