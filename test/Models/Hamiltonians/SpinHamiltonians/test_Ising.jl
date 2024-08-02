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
        @test Hamiltonians.DoF_location(dof) == 1
        @test Hamiltonians.DoF_value(dof) == 1.0
    end

    @testset "BasicIsing" begin
        
        @testset "Construction" begin
            params = Hamiltonians.BasicIsingParameters(1.0)
            latt = Lattices.CubicLattice2D(4, 4)
            ham = Hamiltonians.BasicIsing(latt, params)
            
            @test Hamiltonians.num_DoF(ham) == Lattices.num_sites(latt)
            @test Hamiltonians.DoF(ham, 1) isa Hamiltonians.SpinHamiltonians.IsingDoF
            @test Hamiltonians.DoF(ham, 1) |> Hamiltonians.DoF_location isa Int
            @test Hamiltonians.DoF(ham, 1) |> Hamiltonians.DoF_location == 1
            @test Hamiltonians.DoF(ham, 1) |> Hamiltonians.DoF_value isa typeof(params.Jex)
        end
        
        @testset "Iteration" begin
            params = Hamiltonians.BasicIsingParameters(1.0)
            latt = Lattices.CubicLattice2D(4, 4)
            ham = Hamiltonians.BasicIsing(latt, params)
            
            @testset "ByLocation" begin
                locs = []
                for dof ∈ Hamiltonians.IterateByLocation(ham)
                    push!(locs, Hamiltonians.DoF_location(dof))
                end
                @test all( locs .== range(1, Lattices.num_sites(latt)) )
            end
            
            @testset "AtRandom" begin
                locs = []
                iters = []
                for (iter, dof) ∈ enumerate(Hamiltonians.IterateAtRandom(ham))
                    push!(locs, Hamiltonians.DoF_location(dof))
                    push!(iters, iter)
                end
                @test 1 ≤ minimum( unique(locs) )
                @test Hamiltonians.num_sites(latt) ≥ maximum( unique(locs) )
                @test all( iters .== range(1, Lattices.num_sites(latt)) )
            end

            @testset "Allocations" begin
                bm = @benchmark iterate( Hamiltonians.IterateByLocation($ham) )
                @test bm.allocs == 0
                bm = @benchmark iterate( Hamiltonians.IterateAtRandom($ham) )
                @test bm.allocs == 0
            end
        end

        @testset "State" begin
            params = Hamiltonians.BasicIsingParameters(1.0)
            latt = Lattices.CubicLattice2D(4, 4)
            ham = Hamiltonians.BasicIsing(latt, params)
            
            @test_throws DimensionMismatch Hamiltonians.set_state!(ham, ones(4))
            
            Hamiltonians.set_state!(ham, ones(Hamiltonians.num_DoF(ham)))
            @test Hamiltonians.magnetization(ham) == Hamiltonians.num_DoF(ham)
            @test Hamiltonians.energy(ham, latt) == Hamiltonians.ground_state_energy(ham)
            @test Hamiltonians.current_state(ham, 1) == Hamiltonians.SpinHamiltonians.IsingDoF(1, 1.0)
            @test Hamiltonians.proposed_state(ham, 1) == Hamiltonians.SpinHamiltonians.IsingDoF(1, -1.0)
            @test Hamiltonians.DoF_energy_change(ham, latt, 1) == Lattices.NN_SQUARE_LATT * params.Jex * 2
            Hamiltonians.set_state!(ham, Hamiltonians.proposed_state(ham, 1))
            @test Hamiltonians.DoF_energy_change(ham, latt, 1) == -Lattices.NN_SQUARE_LATT * params.Jex * 2
            
            Hamiltonians.set_state!(ham, -ones(Hamiltonians.num_DoF(ham)))
            @test Hamiltonians.magnetization(ham) == -Hamiltonians.num_DoF(ham)
            @test Hamiltonians.energy(ham, latt) == Hamiltonians.ground_state_energy(ham)
            @test Hamiltonians.current_state(ham, 1) == Hamiltonians.SpinHamiltonians.IsingDoF(1, -1.0)
            @test Hamiltonians.proposed_state(ham, 1) == Hamiltonians.SpinHamiltonians.IsingDoF(1, 1.0)
            @test Hamiltonians.DoF_energy_change(ham, latt, 1) == Lattices.NN_SQUARE_LATT * params.Jex * 2
            Hamiltonians.set_state!(ham, Hamiltonians.proposed_state(ham, 1))
            @test Hamiltonians.DoF_energy_change(ham, latt, 1) == -Lattices.NN_SQUARE_LATT * params.Jex * 2
            
            bm = @benchmark Hamiltonians.magnetization($ham)
            @test bm.allocs == 0
            bm = @benchmark Hamiltonians.energy($ham, $latt)
            @test bm.allocs == 0
            bm = @benchmark Hamiltonians.current_state($ham, 1)
            @test bm.allocs == 0
            bm = @benchmark Hamiltonians.proposed_state($ham, 1)
            @test bm.allocs == 0
            bm = @benchmark Hamiltonians.DoF_energy_change($ham, $latt, 1)
            @test bm.allocs == 0
        end

    end

end