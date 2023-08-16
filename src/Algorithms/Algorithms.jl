module Algorithms

using ..TRExMC
import ..TRExMC: AbstractModel # import and export this just to make the name available

export AbstractModel, procedure, @algorithm

abstract type AbstractAlgorithm end
procedure(::alg_t, args...) where alg_t <: AbstractAlgorithm = throw(ArgumentError("No procedure has been defined for $alg_t types.")) 

"""
    @algorithm
"""
macro algorithm(export_alg::Bool, name::Union{Symbol, String}, fxns...)
    esc(_algorithm(export_alg, name, fxns...))
end
macro algorithm(name::Union{Symbol, String}, fxns...)
    esc(_algorithm(false, name, fxns...))
end

# This should be optimized away at compile time 
# if there are no errors. Be sure to check with
# @code_typed 
function _check_func(name, idx, func::F) where F
    func isa Function ? nothing : throw(ArgumentError("@algorithm $name argument $idx, $func::$(func |> typeof), is not a function."))
end

# TODO: Is it worth fixing this?
# function _check_for_Algorithms()
#     check_Algs = quote
#         :TRExMC ∈ names(Main; imported = true) ? nothing : throw(ErrorException("Somehow you managed to call @algorithm without importing TRExMC. This is impressive."))
#         # :Algorithms ∈ names(Main; imported = true) ? nothing : throw(ErrorException("Somehow you managed to call @algorithm without importing Algorithms. This is impressive."))
#     end
#     return check_Algs |> Base.remove_linenums!
# end

function _define_procedure(export_alg, name, fxns...)
    name = Symbol(name)
    expr = Expr(:block)
    expr.args = [:( import .Algorithms: procedure )]
    push!(expr.args, :( procedure(::$name) = Algorithms._algorithm_setup($export_alg, $name, $(fxns...)) |> Base.remove_linenums! ) )
    if export_alg
        push!(expr.args, :(export procedure))
    end
    return expr |> Base.remove_linenums!
end

_struct_setup(name) = (name = Symbol(name); :( struct $name <: Algorithms.AbstractAlgorithm end )) |> Base.remove_linenums!

function _body_setup(name, fxns...)
    name = Symbol(name)
    body_expr = Expr(:block)
    for (idx, func) ∈ enumerate(fxns)
        push!( body_expr.args, :( Algorithms._check_func($name, $idx, $func); $func(m, args...) ).args... )
    end
    return body_expr |> Base.remove_linenums!
end

function _constructor_overload(name, fxns...)
    name = Symbol(name)
    return quote
        function $name(m::AbstractModel, args...)
            $(_body_setup(name, fxns...))
            return m
        end
    end |> Base.remove_linenums!
end

function _algorithm_setup(export_alg, name, fxns...)    
    name = Symbol(name)
    expr = quote
        $(_struct_setup(name))
        $(_constructor_overload(name, fxns...))
    end
    if export_alg
        push!(expr.args, :(export $name))
    end
    return expr |> Base.remove_linenums!
end

function _algorithm(export_alg, name, fxns...)
    expr = Expr(:block)
    # expr = _check_for_Algorithms()
    append!(expr.args, _algorithm_setup(export_alg, name, fxns...).args)
    append!(expr.args, _define_procedure(export_alg, name, fxns...).args)
    push!(expr.args, :(methods($(Symbol(name)))))
    return expr |> Base.remove_linenums!
end

include("Canonical/Canonical.jl")
export Canonical

end # Algorithms