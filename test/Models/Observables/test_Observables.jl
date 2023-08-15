using Test
using TRExMC

@info "↳ Testing Observables" 
@testset "Observables.jl" begin
    
    @testset "AbstractObservables" begin
        struct FakeObservable <: Observables.AbstractObservables end
        @test_throws ArgumentError measure!(FakeObservable()) 
        @test_throws ArgumentError measure!(FakeObservable(), 1) 
        @test_throws ArgumentError measure!(FakeObservable(), 1, 2) 
    end

    @testset "NullObservable" begin
        @test measure!(Observables.NullObservable()) isa Nothing
        @test measure!(Observables.NullObservable(), 1) isa Nothing
        @test measure!(Observables.NullObservable(), 1, 2) isa Nothing
    end

end