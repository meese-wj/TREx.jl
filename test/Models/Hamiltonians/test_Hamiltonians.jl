using Test
using TREx

@info "↳ Testing Hamiltonians"
@testset "Hamiltonians.jl" begin
    
    @testset "Testing AbstractDoF" begin
        struct FakeDoF <: Hamiltonians.AbstractDoF end
        @test_throws ArgumentError Hamiltonians.location(FakeDoF())        
        @test_throws ArgumentError Hamiltonians.value(FakeDoF())        
    end

    include("SpinHamiltonians/test_SpinHamiltonians.jl")

end