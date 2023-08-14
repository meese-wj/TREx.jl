
using ..Parameters

export location, value, DoF, energy, DoF_energy, num_DoF,
       BasicIsingHamiltonian, BasicIsingParameters


abstract type AbstractIsingHamiltonian <: AbstractSpinHamiltonian end

struct IsingDoF{T <: AbstractFloat} <: AbstractDoF
    site::Int
    spin::T
end
location(dof::IsingDoF) = dof.site
value(dof::IsingDoF) = dof.spin

struct BasicIsingParameters{T <: AbstractFloat} <: Parameters.HamiltonianParameters
    Jex::T  # Ising exchanges. Jex > 0 is ferromagnetic
end

struct BasicIsingHamiltonian{T <: AbstractFloat} <: AbstractIsingHamiltonian
    params::BasicIsingParameters{T}
    spins::Vector{T}

    function BasicIsingHamiltonian(latt, params::BasicIsingParameters{T}) where T
        ndofs = num_sites(latt)
        return new{T}(params, rand([one(T), -one(T)], ndofs))
    end
end

spins(ham::BasicIsingHamiltonian) = ham.spins
num_DoF(ham::BasicIsingHamiltonian) = length(ham.spins)
DoF(ham::BasicIsingHamiltonian, loc) = IsingDoF( loc, spins(ham)[loc] )
# DoF(ham::BasicIsingHamiltonian, loc) = ( loc, spins(ham)[loc] )

