using CSV, DataFrames, LinearAlgebra, Graphs, Tables
include("../_Modular Functions/helperFunctions.jl")

function loadMITGraphFlat(dims)
    path = "./Thesis/Code/Graph Series/MIT1"
    names = readdir(path)

    n, d = dims

    time_graphs = []
    for i in 1:length(names)
        temp = CSV.read(string(path, "/time ", i, ".csv"), DataFrame)
        push!(time_graphs, Matrix(temp[:,:]))
    end

    true_data = zeros(Float16, d*n, length(names))

    

    for i in 1:length(names)
        L, R = do_the_rdpg(time_graphs[i], convert(Int, d))
        true_data[:,i] = reshape([L; R], d*n)

    end
    return true_data, time_graphs
end

function loadMITGraphFlat()
    path = "./Thesis/Code/Graph Series/MIT1"
    names = readdir(path)

    n, d = dims

    time_graphs = []
    for i in 1:length(names)
        temp = CSV.read(string(path, "/time ", i, ".csv"), DataFrame)
        push!(time_graphs, Matrix(temp[:,:]))
    end

    true_data = zeros(Float16, d*n, length(names))

    

    for i in 1:length(names)
        L, R = do_the_rdpg(time_graphs[i], convert(Int, d))
        true_data[:,i] = reshape([L; R], d*n)

    end
    return true_data, time_graphs
end