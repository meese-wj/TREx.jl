module Parameters

using Configurations

export thermalization_sweeps, measurement_sweeps

abstract type AbstractTRExMCParameters end
abstract type LatticeParameters <: AbstractTRExMCParameters end
abstract type HamiltonianParameters <: AbstractTRExMCParameters end
abstract type ModelParameters <: AbstractTRExMCParameters end
abstract type SimulationParameters <: AbstractTRExMCParameters end

thermalization_sweeps(::param_t) where param_t <: SimulationParameters = throw(ArgumentError("thermalization_sweeps have yet to be defined for $param_t types."))
measurement_sweeps(::param_t) where param_t <: SimulationParameters = throw(ArgumentError("measurement_sweeps have yet to be defined for $param_t types."))

@option struct MetropolisParameters <: SimulationParameters
    therm_sweeps::Int = Int(2^18)
    mc_sweeps::Int = Int(2^12)
    temperatures::Vector{Float64} = [1.0] 
end

thermalization_sweeps(p::MetropolisParameters) = p.therm_sweeps
measurement_sweeps(p::MetropolisParameters) = p.mc_sweeps

end # Parameters