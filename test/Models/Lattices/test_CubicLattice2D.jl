using Test
using TREx

@info " ↳ Testing CubicLattice2D..."
@time @testset "CubicLattice2D" begin
    latt = Lattices.CubicLattice2D( 4, 4 )
    params = Lattices.parameters(latt)
    
    println("  Testing Parameters")
    @time @testset "Parameters" begin
        @test params.Lx == 4
        @test params.Ly == 4
        @test all( size(params) .== (4, 4) )     
        @test all( size(Lattices.parameters(latt)) .== (4, 4) )     
    end

    println("  Testing Structure")
    @time @testset "Structure" begin
        @test Lattices.num_sites(latt) == 16
        @test size(latt.neighbors) == (16, 4)
    end
    println()

    println("  Testing Neighborhood")
    @time @testset "Neighborhood" begin
        @testset "y = 1" begin
            @test Lattices.nearest_neighbors(latt, 1) == [13, 4, 2, 5]
            @test Lattices.nearest_neighbors(latt, 2) == [14, 1, 3, 6]
            @test Lattices.nearest_neighbors(latt, 3) == [15, 2, 4, 7]
            @test Lattices.nearest_neighbors(latt, 4) == [16, 3, 1, 8]
        end
        
        @testset "y = 2" begin
            @test Lattices.nearest_neighbors(latt, 5) == [1, 8, 6, 9]
            @test Lattices.nearest_neighbors(latt, 6) == [2, 5, 7, 10]
            @test Lattices.nearest_neighbors(latt, 7) == [3, 6, 8, 11]
            @test Lattices.nearest_neighbors(latt, 8) == [4, 7, 5, 12]
        end
        
        @testset "y = 3" begin
            @test Lattices.nearest_neighbors(latt, 9)  == [5, 12, 10, 13]
            @test Lattices.nearest_neighbors(latt, 10) == [6, 9, 11, 14]
            @test Lattices.nearest_neighbors(latt, 11) == [7, 10, 12, 15]
            @test Lattices.nearest_neighbors(latt, 12) == [8, 11, 9, 16]
        end
        
        @testset "y = 4" begin
            @test Lattices.nearest_neighbors(latt, 13) == [9, 16, 14, 1]
            @test Lattices.nearest_neighbors(latt, 14) == [10, 13, 15, 2]
            @test Lattices.nearest_neighbors(latt, 15) == [11, 14, 16, 3]
            @test Lattices.nearest_neighbors(latt, 16) == [12, 15, 13, 4]
        end
    end
    println()

    println("  Total testset timing:")
end