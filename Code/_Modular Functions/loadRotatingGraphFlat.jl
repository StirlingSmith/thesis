using CSV, DataFrames, LinearAlgebra, Graphs
include("../_Modular Functions/helperFunctions.jl")

function loadRotatingGraphFlat()
    path = "./Code/Graph Series/Rotating Edge Graph"
    names = readdir(path)

    n, d = dims

    time_graphs = []
    for i in 1:length(names)
        push!(time_graphs, adjacency_matrix(loadgraph(string(path, "/toy_graph_", i, ".lg"))))
    end

    true_data = zeros(Float64, d*n, length(names))

    

    for i in 1:length(names)
        L, R = do_the_rdpg(time_graphs[i], convert(Int64, d))
        true_data[:,i] = reshape([L; R], d*n)

    end
    return true_data, time_graphs
end