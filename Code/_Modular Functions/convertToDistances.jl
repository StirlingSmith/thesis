using LinearAlgebra, Distances

function convertToDistances(p1::AbstractVector, p2::AbstractVector, distance_metric=cosine_dist)::Float64
    distance_metric(p1,p2)
end

