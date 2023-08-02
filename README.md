# TREx.jl
## Thermodynamics via Replica Exchange

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://meese-wj.github.io/TREx.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://meese-wj.github.io/TREx.jl/dev/)
[![Build Status](https://github.com/meese-wj/TREx.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/meese-wj/TREx.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/meese-wj/TREx.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/meese-wj/TREx.jl)

*A Julia package for simulating statistical mechanics with massively-parallel Monte Carlo methods.*

This package is currently under development. I hope to have it up and running soon. Stay tuned for details.

## Package Motivation

The goal for this package is to provide a relatively simple *Julian* API for simulating thermodynamical quantities in statistical mechanics with Monte Carlo methods. As the title implies, the methods of interest focus on *replica-exchange*, or massively-parallel simulation of systems that occasionally swap information for mutually faster convergence.

With this said, a helpful user interface is important for usability and ultimately reproducibility of scientific results. We therefore place some constraints on how one can actually access the high-performance code. Luckily, the Julia type system with multiple-dispatch can do this for us.

## Package Organization

In our view, any Monte Carlo simulation can be disected into a set of interacting black boxes. These include

1. [`Parameters`](src/Parameters/): the data structures that act as experimental knobs with which one tunes a simulation.
1. [`Models`](src/Models): the data structure that contains all relevant information for the system being simulated. The `model`s encapsulate the following data structures:
    1. [`Lattices`](src/Lattices/): the underlying geometry in which a system evolves during a simulation.
    1. [`Hamiltonians`](src/Hamiltonians/): the data structure that contains all of a system's degrees of freedom and how they interact amongst themselves. (In many ways this *defines* the system itself.)
    1. [`Observables`](src/Models/Observables): the thermodynamic quantities to be sampled during the Monte Carlo simulation.
1. [`Algorithms`](src/Algorithms/): the Monte Carlo methods used to define individual time-steps in the simulation. These also update the system itself.
1. [`Simulations`](src/Simulations/): the set of `main` functions that actually perform a simulation.

Each of these pieces are defined through a series of methods and types whose implementations are independent. Because of this, each of these pieces are separated as submodules (in the Julian sense). We also deliberately choose to trap the exported names from these submodules within `TREx`. This reduces the amount of clutter in the namespace, even though I admit that needing to write things, like `Hamiltonians.Ising` may get annoying at times. 🙃

## Citing 

**When the time comes...**

Eventually, my goal is to publish on this repo, but right now I don't have squat for it. The infrastructure was put into place by `PkgTemplates.jl` for me though.

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).
