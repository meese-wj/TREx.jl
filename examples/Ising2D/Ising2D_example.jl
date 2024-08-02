"""
This script will execute an example
2D Ising model Monte Carlo simulation.
"""

using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

using TRExMC

# Step 1: Define Parameters
Lsize = 12
Jex = 1.0
Temp = 2.3Jex
ham_params = Hamiltonians.BasicIsingParameters(Jex)
metro_params = Parameters.MetropolisParameters(2^18, 2^10, [Temp])

# Step 2: Create the model
latt = Lattices.CubicLattice2D(Lsize, Lsize)
ham = Hamiltonians.BasicIsing(latt, ham_params)
obs = Observables.NullObservable()
ising_model = Model(latt, ham, obs)

# Step 3: Thermalize the model
@show @time Hamiltonians.energy(ising_model)
@time begin
    for _ ∈ range(1, thermalization_sweeps(metro_params))
        Algorithms.Canonical.metropolis_sweep!(ising_model, metro_params.temperatures[begin])
    end
end 
@show @time Hamiltonians.energy(ising_model)

# Step 4: Measure the model

# Step 5: Analyze the statistics