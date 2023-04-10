using Test
include("main.jl")

@testset "evaluate" begin
    @test evaluate([0, 0, 0, 0, 0, 0, 0, 0]) == 0
    @test evaluate([1, 1, 1, 1, 1, 1, 1, 1]) ≈ 1.2246467991473532e-16
    @test evaluate([0, 0, 1, 0, 0, 0, 0, 1]) ≈ 0.3954512068705425 
end

@testset "randpop" begin
    data = randpop(5)
    @test size(data) == (5, 8)
    @test all(x -> x ∈ [0, 1], data)
end

@testset "select" begin
    data = select(5, 2)
    @test size(data) == (2,)
    @test all(x -> x ∈ 1:5, data)
end

@testset "crossover" begin
    data = crossover([1 0 1 0 1 0 1 0; 0 1 0 1 0 1 0 1])
    @test size(data) == (8,)
    @test all(x -> x ∈ [0, 1], data)
end

@testset "mutation" begin
    data = mutation([1, 0, 1, 0, 1, 0, 1, 0])
    @test size(data) == (8,)
    @test all(x -> x ∈ [0, 1], data)
end