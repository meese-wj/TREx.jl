
using ..Parameters

export location, value, DoF, energy, DoF_energy, num_DoF,
       BasicIsing, BasicIsingParameters


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

struct BasicIsing{T <: AbstractFloat} <: AbstractIsingHamiltonian
    params::BasicIsingParameters{T}
    spins::Vector{T}

    function BasicIsing(latt, params::BasicIsingParameters{T}) where T
        ndofs = num_sites(latt)
        return new{T}(params, rand([one(T), -one(T)], ndofs))
    end
end

spins(ham::BasicIsing) = ham.spins
num_DoF(ham::BasicIsing) = length(ham.spins)
DoF(ham::BasicIsing, loc) = IsingDoF( loc, spins(ham)[loc] )

