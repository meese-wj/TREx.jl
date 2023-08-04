
export metropolis_sweep!

function metropolis_move!(model, dof_site, dof_value, mcparams)
    old_state = current_state(model, dof_site, dof_value)
    new_state = proposed_move(model, dof_site, dof_value)
    ΔE = energy_change(model, new_state, old_state)
    if ΔE < zero(ΔE) || rng(model) < @fastmath exp( -ΔE / temperature(mcparams) )
        set_state!(model, dof_site, new_state)
    end
    return model
end


function metropolis_sweep!(model, mcparams)
    for dof ∈ iterate_dofs(model)
        metropolis_move!(model, location(dof), value(dof), mcparams)
    end
    return model
end