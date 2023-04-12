using Random
using ProgressBars
using Statistics
using Plots

f(x::Int64) = sin(x / 255 * pi)
"""
    ⊛(x::Int64, p::Float64)
Operator ⊛ est un opérateur de mutation. Il prend en entrée un bit et une probabilité de mutation.
Si la probabilité est inférieure à un nombre aléatoire entre 0 et 1, le bit est muté, sinon il est conservé.
# Arguments:
- `x::Int64` est le bit à muter
- `p::Float64` est la probabilité de mutation
# Returns:
- `Int64` est le bit muté
"""
⊛(x::Int64, p::Float64)::Int64 = (rand() < p) ? x ⊻ 1 : 0 ⊻ x

function evaluate(x::Vector{Int64})::Float64
    return f(join(x) |> x -> parse(Int64, x, base=2))
end

function randpop(popsize::Int64)::Matrix{Int64}
    return rand(0:1, popsize, 8)
end


function select(popsize::Int64, n_parents::Int64)::Vector{Int64}
    return randperm(popsize)[1:n_parents]
end

function make_mates(population::Matrix{Int64}, n_parents::Int64, n_mates::Int64)::Tuple
    mates::Tuple = ()
    for _ in 1:n_mates
        indices::Vector{Int64} = select(size(population)[1], n_parents)
        mates = (mates..., (population[indices[1], :], population[indices[2], :]))
    end
    return mates
end

function crossover(parents::Matrix{Int64})::Vector{Int64}
    return [rand([x, y]) for (x, y) in zip(parents[1, :], parents[2, :])]
end

function mutation(child::Vector{Int64})
    probability = 0.125
    return [x ⊛ probability for x in child]
end

function survival(n_survivors::Int64, population::Matrix{Int64})
    evaluations = mapslices(evaluate, population, dims=2)
    indices_tries = sortperm(vec(evaluations), rev=true)
    return population[indices_tries[1:n_survivors], :]
end

function eliminate_duplicates(population::Matrix{Int64})
    return unique(population, dims=1)
end

function average_fitness(population::Matrix{Int64})
    return mean(mapslices(evaluate, population, dims=2))
end
function plot_evolution(max_fitness::Vector, min_fitness::Vector, avg_fitness::Vector)
    plot(1:length(max_fitness), max_fitness, label="max fitness", xlabel="generation", ylabel="fitness", title="Evolution of the fitness")
    plot!(1:length(min_fitness), min_fitness, label="min fitness")
    plot!(1:length(avg_fitness), avg_fitness, label="avg fitness")
end
function main(debug::Bool=false)
    pop_size::Int64 = 5
    n_gen = 5
    n_parents = 2
    n_mates = 50
    max_fitness = []
    min_fitness = []
    avg_fitness = []

    for _ in tqdm(1:n_gen)
        population::Matrix{Int64} = randpop(pop_size)
        mates::Tuple = make_mates(population, n_parents, n_mates)
        children = [crossover(Matrix(hcat(mates[i]...)')) for i in 1:n_mates] |> x -> Matrix(hcat(x...)') |> x -> eliminate_duplicates(x)
        # display(children)
        population = [population; children] |> x -> survival(pop_size, x)
     
        max_fitness = [max_fitness; maximum(mapslices(evaluate, population, dims=2))]
        min_fitness = [min_fitness; minimum(mapslices(evaluate, population, dims=2))]
        avg_fitness = [avg_fitness; average_fitness(population)]
    end
    plot_evolution(max_fitness, min_fitness, avg_fitness)
end

main()