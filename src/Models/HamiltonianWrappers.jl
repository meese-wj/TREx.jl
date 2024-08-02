
import .Hamiltonians: energy, current_state, proposed_state, DoF_energy_change, set_state!
export iterate_DoFs, energy, current_state, proposed_state, DoF_energy_change, set_state!

"""
    iterate_DoFs(m::AbstractModel)

Wrapper to extract the `Hamiltonian` from the `Model` and 
iterate.
"""
iterate_DoFs(m::AbstractModel) = DefaultIterator(rng(m), hamiltonian(m))

# TODO: Probably just scriptify these
Hamiltonians.energy(m::AbstractModel, args...) = Hamiltonians.energy(hamiltonian(m), lattice(m), args...)
Hamiltonians.current_state(m::AbstractModel, args...) = Hamiltonians.current_state(hamiltonian(m), args...)
Hamiltonians.proposed_state(m::AbstractModel, args...) = Hamiltonians.proposed_state(hamiltonian(m), args...)
Hamiltonians.DoF_energy_change(m::AbstractModel, args...) = Hamiltonians.DoF_energy_change(hamiltonian(m), lattice(m), args...)
Hamiltonians.set_state!(m::AbstractModel, args...) = Hamiltonians.set_state!(hamiltonian(m), args...)
