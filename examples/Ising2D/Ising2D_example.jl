"""
This script will execute an example
2D Ising model Monte Carlo simulation.
"""

using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

using TRExMC

# Step 1: Define Parameters
Lsize = 16
Jex = 1.0
Temp = 1000Jex
ham_params = Hamiltonians.BasicIsingParameters(Jex)
metro_params = Parameters.MetropolisParameters(2^16, 2^10, [Temp])

# Step 2: Create the model
latt = Lattices.CubicLattice2D(Lsize, Lsize)
ham = Hamiltonians.BasicIsing(latt, ham_params)
obs = Observables.NullObservable()
ising_model = Model(latt, ham, obs)

# Step 3: Thermalize the model
# @time Hamiltonians.energy(ising_model)
t = @timed begin
    for _ ∈ range(1, thermalization_sweeps(metro_params))
        Algorithms.Canonical.metropolis_sweep!(ising_model, metro_params.temperatures[begin])
    end
end 
println("\nTotal Sweeps: $(thermalization_sweeps(metro_params) |> Float64)")
println("Total Updates: $(Lsize^2 * thermalization_sweeps(metro_params) |> Float64)")
println("Total Time: $(t.time) s")
println("Sweep Frequency: $(round(thermalization_sweeps(metro_params) / t.time; sigdigits = 3)) Hz")
println("Update Frequency: $(round(Lsize^2 * thermalization_sweeps(metro_params) / t.time; sigdigits = 3)) Hz")
# @time Hamiltonians.energy(ising_model)

# Step 4: Measure the model

# Step 5: Analyze the statistics