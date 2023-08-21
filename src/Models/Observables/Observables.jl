module Observables

export AbstractObservables, measure!, @observables

"""
    abstract type AbstractObservables end

Parent type for all observables.

# Required Interface

The following methods must be implemented for all subtypes:

    * [`measure!`](@ref): how one should take measurements of a system for a given system configuration.
"""
abstract type AbstractObservables end

measure!(::obs_t, args...) where obs_t <: AbstractObservables = throw(ArgumentError("No measure! function has been provided for $obs_t types."))

"""
    NullObservable <: AbstractObservables

Empty observable used for testing purposes.
"""
struct NullObservable <: AbstractObservables end
measure!(obs::NullObservable, args...) = nothing 

"""
    @observables name symbols funcs

Generate an [`AbstractObservables`](@ref) subtype with the given `name`
whose fields will be denoted by the given `symbols` iterable. The [`measure!`](@ref)
method will also be implemented with the supplied [`funcs`] iterable.

!!! note
    `length(symbols) == length(funcs)` by construction.
"""
macro observables(name, symbols, funcs)
    _observables(name, symbols, funcs)
end

end # Observables