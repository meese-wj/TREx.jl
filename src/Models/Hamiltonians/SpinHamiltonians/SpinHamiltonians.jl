module SpinHamiltonians

using ..Parameters
using ..Hamiltonians
using ..Lattices

# Pull in methods to overload in this module
import ..Hamiltonians: location, value, DoF, energy, DoF_energy, num_DoF

abstract type AbstractSpinHamiltonian <: AbstractHamiltonian end

include("Ising.jl")

end # SpinHamiltonians