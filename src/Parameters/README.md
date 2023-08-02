# TREx.Parameters

The `Parameters.jl` file defines a type hierarcy starting from the `AbstractTRExParameters` type. It has two main subtypes, both of which are `abstract`, given by 

1. `ModelParameters <: AbstractTRExParameters`: abstract parent type for all parameter structs used for the `Models`.
1. `SimulationParameters <: AbstractTRExParameters`: abstract parent type for all parameter structs used in the `Simulations`.

## `ModelParameters`

*To be continued...*

## `SimulationParameters`

This is an API for all parameters structs that are subtypes of the `SimulationParameters`. There are only two important interface methods that *must* be defined for a subtype: `thermalization_sweeps` and `measurement_sweeps`. Using our given `Parameters.MetropolisParameters` as an example, we have

```julia
using TREx
using Configurations

@option struct MetropolisParameters <: Parameters.SimulationParameters
    therm_sweeps::Int = Int(2^18)
    mc_sweeps::Int = Int(2^12)
    temperatures::Vector{Float64} = [1.0] 
end

TREx.thermalization_sweeps(p::MetropolisParameters) = p.therm_sweeps
TREx.measurement_sweeps(p::MetropolisParameters) = p.mc_sweeps
```

where we have used the [`Configurations.jl`](https://configurations.rogerluo.dev/stable/) package for a nice parameter interface. This structure would then by the default type passed as the `mcparams` argument in the [`Simulations.jl`](../Simulations/Simulations.jl) functions.