"""
This script will execute an example
2D Ising model Monte Carlo simulation.
"""

using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

using TRExMC

@show names(TRExMC)