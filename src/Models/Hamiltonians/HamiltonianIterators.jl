
using Base
using Random

export iterate, hamiltonian, IterateByLocation, IterateAtRandom

"""
    abstract type AbstractHamiltonianIterator end

Iterface for iteration through a given Hamiltonian.
"""
abstract type AbstractHamiltonianIterator end
hamiltonian(itr::AbstractHamiltonianIterator) = itr.ham
DoF(itr::AbstractHamiltonianIterator, location) = DoF(itr |> hamiltonian, location)  

_iter_done(DoFstate::Tuple{<: AbstractHamiltonianIterator, Int}) = DoFstate[end] > num_DoF(DoFstate[begin] |> hamiltonian)

Base.iterate(itr::AbstractHamiltonianIterator, args...) = throw(ArgumentError("No iteration technique has been defined for $(itr | typeof) types."))

struct IterateByLocation{H <: AbstractHamiltonian} <: AbstractHamiltonianIterator
    ham::H
end

function Base.iterate(itr::IterateByLocation, DoFstate = (DoF(itr, 1), 1))
    next_location = DoFstate[end] + 1
    next_DoFstate = (DoFstate[begin], next_location)
    if _iter_done(next_DoFstate)
        return nothing
    end
    return (DoFstate, next_location)
end

struct IterateAtRandom{RNG <: AbstractRNG, H <: AbstractHamiltonian} <: AbstractHamiltonianIterator
    rng::RNG
    ham::H
end

IterateAtRandom(ham) = IterateAtRandom(Random.GLOBAL_RNG, ham)

_random_location(itr) = rand(itr.rng, 1:num_DoF(itr |> hamiltonian))

function Base.iterate(itr::IterateAtRandom, DoFstate = (DoF(itr, _random_location(itr)), 1) )
    next_iteration = DoFstate[end] + 1
    next_DoFstate = (DoFstate[begin], next_iteration)
    if _iter_done(next_DoFstate)
        return nothing
    end
    randloc = _random_location(itr)
    return ( DoF(itr, randloc), next_iteration )
end