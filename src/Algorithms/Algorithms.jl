module Algorithms

using ..TRExMC
import ..TRExMC: Model # import and export this just to make the name available

export Model, @algorithm

abstract type AbstractAlgorithm end

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

function _algorithm(export_alg, name, fxns...)    
    name = Symbol(name)
    str_expr = :( struct $name <: Algorithms.AbstractAlgorithm end )
    body_expr = Expr(:block)
    body_expr.args = [ :( Algorithms._check_func($name, $idx, $func); $func(m, args...) ) for (idx, func) ∈ enumerate(fxns) ]

    func_expr = :(
        function $name(m, args...)
            $body_expr
            return m
        end
    )
    
    expr = quote
        $str_expr
        $func_expr
    end
    if export_alg
        push!(expr.args, :(export $name))
    end
    return expr |> Base.remove_linenums!
end

include("Canonical/Canonical.jl")
export Canonical

end # Algorithms