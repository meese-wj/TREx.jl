
using Random
export metropolis_sweep!

function metropolis_move!(model, dof_site, temperature)
    old_state = Models.current_state(model, dof_site)
    new_state = Models.proposed_state(model, dof_site)
    ΔE = Models.DoF_energy_change(model, old_state, new_state)
    if ΔE < zero(ΔE) || rand(Models.rng(model)) < @fastmath exp( -ΔE / temperature )
        Models.set_state!(model, new_state)
    end
    return model
end


function metropolis_sweep!(model, current_temperature)
    for dof ∈ Models.iterate_DoFs(model)
        metropolis_move!(model, Models.DoF_location(dof), current_temperature)
    end
    return model
end

@algorithm true Metropolis! metropolis_sweep!