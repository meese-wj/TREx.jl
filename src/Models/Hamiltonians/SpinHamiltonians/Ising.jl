
using ..Parameters

export location, value, DoF, energy, DoF_energy, DoF_energy_change, num_DoF,
       current_state, proposed_state, set_state!,
       BasicIsing, BasicIsingParameters, 
       ground_state_energy, magnetization

abstract type AbstractIsingHamiltonian <: AbstractSpinHamiltonian end

struct IsingDoF{I <: Integer, T <: AbstractFloat} <: AbstractDoF
    site::I
    spin::T
end
DoF_location(dof::IsingDoF) = dof.site
DoF_value(dof::IsingDoF) = dof.spin

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

current_state(ham::BasicIsing, loc) = DoF(ham, loc)
function proposed_state(ham::BasicIsing, loc) 
    dof = DoF(ham, loc)
    IsingDoF(DoF_location(dof), -DoF_value(dof))
end

function set_state!(ham::BasicIsing, dof::IsingDoF)
    ham.spins[DoF_location(dof)] = DoF_value(dof)
end

function set_state!(ham::BasicIsing, spins)
    length(spins) == num_DoF(ham) ? nothing : throw(DimensionMismatch("The number of provided spins ($(length(spins))) does not match the number of degrees of freedom ($(num_DoF(ham)))."))
    for dof ∈ IterateByLocation(ham)
        loc = DoF_location(dof)
        set_state!(ham, IsingDoF(loc, spins[loc]))
    end
    return ham
end

function DoF_energy(ham::BasicIsing, latt, dof)
    loc = DoF_location(dof)
    val = DoF_value(dof)
    eff_field::typeof(val) = zero(val)
    for nn ∈ nearest_neighbors(latt, loc)
        eff_field += DoF(ham, nn) |> DoF_value
    end
    return -ham.params.Jex * val * eff_field
end

function DoF_energy_change(ham::BasicIsing, latt, olddof::IsingDoF, newdof::IsingDoF)
    return DoF_energy(ham, latt, newdof) - DoF_energy(ham, latt, olddof)
end

function DoF_energy_change(ham::BasicIsing, latt, loc)
    DoF_energy_change(ham, latt, current_state(ham, loc), proposed_state(ham, loc))
end

function energy(ham::BasicIsing{T}, latt) where T
    en::T = zero(T)
    for dof ∈ IterateByLocation(ham)
        en += T(0.5) * DoF_energy(ham, latt, dof)
    end
    return en
end

ground_state_energy(ham::BasicIsing) = -0.5 * Lattices.NN_SQUARE_LATT * ham.params.Jex * Hamiltonians.num_DoF(ham)
magnetization(ham::BasicIsing) = sum(spins(ham))