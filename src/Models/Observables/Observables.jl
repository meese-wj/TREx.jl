module Observables

export AbstractObservables, measure!, @observables, procedure

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
    @observables name symbol_funcs::AbstractDict
    @observables name symbols funcs

Generate an [`AbstractObservables`](@ref) subtype with the given `name`
whose fields will be denoted by the given `symbols` iterable. The [`measure!`](@ref)
method will also be implemented with the supplied [`funcs`] iterable.

Alternatively one can supply a `Dict`ionary of symbol-function pairs as a single
argument.

!!! note
    `length(symbols) == length(funcs)` by construction.
"""
macro observables(name, symbols, funcs)
    esc(_observables(name, eval(symbols), eval(funcs)))
end
macro observables(name, symbol_funcs)
    esc(_observables(name, eval(symbol_funcs)))
end

function _build_structfields(symbols)
    expr = Expr(:block)
    for symb ∈ symbols
        push!(expr.args, :( $symb::Vector{T} ))
    end
    return expr |> Base.remove_linenums!
end

function _build_struct(name, symbols)
    expr = quote
        mutable struct $name{T <: Number} <: Observables.AbstractObservables
            step::Int
            $( _build_structfields(symbols).args... )
        end
    end
    return expr |> Base.remove_linenums!
end

function _build_constructor(name, symbols)
    expr = quote
        function $name(::Type{T}, num_measures::Integer) where T
            arrays = [ zeros(T, num_measures) for _ ∈ range(1, $(length(symbols))) ]
            return $name{T}( oneunit(Int), arrays... )
        end
    end
    return expr |> Base.remove_linenums!
end

function _check_functions(symbols, funcs)
    for (symb, func) ∈ zip(symbols, funcs)
        @assert func isa Function "Supplied function argument $func corresponding to the $symb observable is not a Function subtype."
    end
    return nothing 
end

function _check_observables(symbols, funcs)
    @assert length(symbols) == length(funcs) "The number of observables fields must be equal to the number of methods. Got $(length(symbols)) and $(length(funcs)), respectively."
    return _check_functions(symbols, funcs)
end

function _build_measurement_loop(symbols, funcs)
    expr = Expr(:block)
    for (symb, func) ∈ zip(symbols, funcs)
        push!(expr.args, :( obs.$symb[obs.step] = $func(ham, latt) ) )
    end
    return expr |> Base.remove_linenums!
end

# TODO: Add a catch if the step exceeds the vector size?
function _build_measurements(name, symbols, funcs)
    expr = quote
        function measure!(obs::$name, ham, latt)
            $(_build_measurement_loop(symbols, funcs).args...)
            obs.step += oneunit(obs.step)
        end
    end
    return expr |> Base.remove_linenums!
end

function _observables(name, symbols, funcs)
    _check_observables(symbols, funcs)
    name = Symbol(name)
    symbols = Symbol.(symbols)
    _check_functions(symbols, funcs)
    expr = Expr(:block)
    push!(expr.args, :(import .Observables: measure!))
    push!(expr.args, _build_struct(name, symbols).args...)
    push!(expr.args, _build_constructor(name, symbols).args...)
    push!(expr.args, _build_measurements(name, symbols, funcs).args...)
    push!(expr.args, :(export measure!, $name))
    return expr |> Base.remove_linenums!
end

"""
    _observables(name, symbol_funcs::AbstractDict)
    _observables(name, symbols, funcs)

Return an `Expr`ession used by the [`@observables`](@ref) macro.
"""
_observables(name, symbol_funcs::AbstractDict) = _observables(name, keys(symbol_funcs), values(symbol_funcs))

end # Observables