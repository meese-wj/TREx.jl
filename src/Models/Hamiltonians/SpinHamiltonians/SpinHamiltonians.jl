module SpinHamiltonians

using ..Hamiltonians

abstract type AbstractSpinHamiltonian <: AbstractHamiltonian end

include("Ising.jl")

end # SpinHamiltonians