using DataFrames
using Graphs
using DifferentialEquations
using DiffEqFlux
using OrdinaryDiffEq
using Flux
using Optim
using SymbolicRegression
using LinearAlgebra
using Arpack
using Distances



# function that does svd decomposition
function do_the_rdpg(A,d)
    L,Σ,R = svds(A; nsv=d, v0=[Float64(i%7) for i in 1:minimum(size(A))])[1]
    L̂ = L * diagm(.√Σ)
    R̂ = R * diagm(.√Σ)
    return (L̂ = L̂, R̂ = R̂)
end



# Create function do give neural net an input.

# Function that takes take vertex embedding, one vertex and returns all distances between that vertex and the k closest vertices

function vertex_distances(M, k)
    distances = []  # preallocate sizes
    vertex_norm_distances = []

    for i::Int8 in 1:n                                                 # find closest_vertices to v 
        if i != v
            distance = norm(M[:,v] - M[:,i], 1)
            push!(vertex_norm_distances, (distance, i))
    
        end 
    end

    closest_vertices_to_v = partialsort(vertex_norm_distances,1:k, by=x->x[1])

    for i in 1:length(closest_vertices_to_v)
        vertex_index = closest_vertices_to_v[i][2]           
        for j in 1:size(M)[1]                                          # iterating over all columns in matrix
            push!(distances, M[j, v] - M[j,vertex_index])
        end
    end

    return closest_vertices_to_v
end


function vertex_distances_2(M::Matrix, v::T, k::Integer, distance_metric=cosine_dist) where {T<:AbstractArray}
    cosine_distances = zeros(Float64, size(M)[1])
    
    for i::Int in eachindex(cosine_distances)
        # println("33")
        distance::Float64 = distance_metric(v, M[i,:])  
        # @inbounds cosine_distances[i] = isnan(distance) ? zero(distance) : distance
        cosine_distances[i] = isnan(distance) ? zero(distance) : distance
    end
    closest_cosine_distances= partialsort(cosine_distances,1:k, by=x->x)

    return closest_cosine_distances
end

function includeKNNdists!(û, p::T, M::Matrix) where {T<:AbstractArray}
    cosine_distances = zeros(Float64, size(M)[1])
    
    # for i::Int in eachindex(cosine_distances)
    #     distance::Float64 = cosine_dist(p, M[i,:])  
    #     @inbounds cosine_distances[i] = isnan(distance) ? zero(distance) : distance
    # end
    û[1:dims[2]] .= p
    # û[1+dims[2]:end] .= #partialsort(cosine_distances,1:k, by=x->x)

end

function printall(iter)
    for i in iter
        println(i)
    end
end


function run_test(D,V)
    M = true_data[:,D]
    M = reshape(M, (dims[1],dims[2]))
    
    u0 = M[V,:]
    println("Original Point: ", u0)
    u0 = includeKNNdists(u0, M[1:dims[1].!=V,:])



    M̂ = true_data[:,D+1]
    M̂ = reshape(M̂, (dims[1],dims[2])) 

    u1 = M̂[V,:]
    println("Original Point: ", u0)
    println("True: ",u1)
    println("Pred: ",predict_neuralode(result.u)[1:dims[2], 2])
end

