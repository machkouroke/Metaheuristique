using Random

f(x::Int64) = sin(x/255 * pi)
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
⊛(x::Int64, p::Float64)::Int64 = x ⊻ 1 if (rand() < p) else 0 ⊻ x

function evaluate(x::Vector{Int64})::Float64
    
    evaluation = (join(x) |> x -> parse(Int64, x, base=2))
    @show evaluation
    @show typeof(evaluation)
    return f(evaluation)
end

function randpop(popsize::Int64)::Matrix{Int64}
    return rand(0:1, popsize, 8)
end


function select(popsize::Int64, n_parents::Int64)::Vector{Int64}
    return randperm(popsize)[1:n_parents]
end

function crossover(parents::Matrix{Int64})::Vector{Int64}
    return [rand([x, y]) for (x, y) in zip(parents[1, :], parents[2, :])]
end

function mutation(child::Vector{Int64})
    probability = 0.125
    return [x ⊛ probability for x in child]
end

function survival(f, n_survivors::Int64, population::Matrix{Int64})
    return 
end

function eliminate_duplicates(population::Matrix{Int64})
    return unique(population, dims=1)
end

function plot_evolution(x::Matrix{Int64})
    plot(x, evaluate.(x))
end
function main()
    pop_size::Int64 = 5
    n_gen = 5
    for _ in 1:n_gen
        population = randpop(pop_size) |> eliminate_duplicates 
        parents = population[select(pop_size, 2), :]
        child = crossover(parents)
        population = [population; child]
        population = mutation.(population) |>  x -> survival(evaluate, pop_size, x)
    
        population = eliminate_duplicates(population)
        println(population)
    end
end