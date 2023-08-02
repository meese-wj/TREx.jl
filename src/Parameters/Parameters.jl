module Parameters

using Configurations

export thermalization_sweeps, measurement_sweeps

abstract type AbstractTRExParameters end
abstract type ModelParameters <: AbstractTRExParameters end
abstract type SimulationParameters <: AbstractTRExParameters end

thermalization_sweeps(p::SimulationParameters) = throw(ArgumentError("thermalization_sweeps have yet to be defined for $(p |> typeof) types."))
measurement_sweeps(p::SimulationParameters) = throw(ArgumentError("measurement_sweeps have yet to be defined for $(p |> typeof) types."))

@option struct MetropolisParameters <: SimulationParameters
    therm_sweeps::Int = Int(2^18)
    mc_sweeps::Int = Int(2^12)
    temperatures::Vector{Float64} = [1.0] 
end

thermalization_sweeps(p::MetropolisParameters) = p.therm_sweeps
measurement_sweeps(p::MetropolisParameters) = p.mc_sweeps

end # Parameters