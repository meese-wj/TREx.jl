module SpinHamiltonians

using ..Parameters
using ..Hamiltonians

abstract type AbstractSpinHamiltonian <: AbstractHamiltonian end

include("Ising.jl")

end # SpinHamiltonians