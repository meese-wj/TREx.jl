using Test
using TRExMC
using BenchmarkTools

@info "  ↳ Testing Ising..."
@testset "Ising.jl" begin

    @testset "BasicIsingParameters" begin
        params = Hamiltonians.BasicIsingParameters(1.0)
        @test params.Jex == 1.0
    end
    
    @testset "IsingDoF" begin
        dof = Hamiltonians.SpinHamiltonians.IsingDoF(1, 1.0)
        @test Hamiltonians.location(dof) == 1
        @test Hamiltonians.value(dof) == 1.0
    end

    @testset "BasicIsingHamiltonian" begin
        
        @testset "Construction" begin
            params = Hamiltonians.BasicIsingParameters(1.0)
            latt = Lattices.CubicLattice2D(4, 4)
            ham = Hamiltonians.BasicIsingHamiltonian(latt, params)
            
            @test Hamiltonians.num_DoF(ham) == Lattices.num_sites(latt)
            @test Hamiltonians.DoF(ham, 1) isa Hamiltonians.SpinHamiltonians.IsingDoF
            @test Hamiltonians.DoF(ham, 1) |> Hamiltonians.location isa Int
            @test Hamiltonians.DoF(ham, 1) |> Hamiltonians.location == 1
            @test Hamiltonians.DoF(ham, 1) |> Hamiltonians.value isa typeof(params.Jex)
        end
        
        @testset "Iteration" begin
            params = Hamiltonians.BasicIsingParameters(1.0)
            latt = Lattices.CubicLattice2D(4, 4)
            ham = Hamiltonians.BasicIsingHamiltonian(latt, params)
            
            bm = @benchmark iterate( Hamiltonians.IterateByLocation($ham) )
            @test bm.allocs == 0
            bm = @benchmark iterate( Hamiltonians.IterateAtRandom($ham) )
            @test bm.allocs == 0
        end

        @testset "State" begin
            
        end

    end

end