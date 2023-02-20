"""
    TemporalNetworkEmbedding
    A: The raw embedding array dims = [d*n, :]
    n: The number of nodes in the network
    d: The dimension of the embedding

"""

struct TemporalNetworkEmbedding
    A::Array
    n::Int
    d::Int
end

@inline function Base.getindex(X::TemporalNetworkEmbedding, t::T) where {T<:AbstractFloat} 
    reshape(X.A[:,Int(floor(t))]*(1-t).+X.A[:,Int(ceil(t))]*(t), (X.n,X.d)) # uses linear interpolation between indices
end
# Base.getindex(X::TemporalNetworkEmbedding, t::T) where {T<:AbstractFloat} = reshape(X.A[:,Int(floor(t))], (X.n,X.d)) # this uses the floor of a float index
Base.getindex(X::TemporalNetworkEmbedding, t::T) where {T<:Int} = reshape(X.A[:,t], (X.n,X.d))
Base.getindex(X::TemporalNetworkEmbedding, t::UnitRange{Int64}) = TemporalNetworkEmbedding(X.A[:,t], X.n, X.d)

Base.lastindex(X::TemporalNetworkEmbedding) = size(X.A)[2]
not(t::Bool)=!t
withoutNode(X::TemporalNetworkEmbedding, t::Int) = TemporalNetworkEmbedding(X.A[not.(in.(1:X.n*X.d, [(t-1)*X.d+1:t*X.d])), :], X.n-1, X.d)

targetNode(X::TemporalNetworkEmbedding, t::Int) = TemporalNetworkEmbedding(X.A[in.(1:X.n*X.d,[[t+i*X.n for i in 0:X.d-1]]), :], 1, X.d)

Base.length(X::TemporalNetworkEmbedding) = size(X.A)[2]

Base.iterate(X::TemporalNetworkEmbedding) = [X[i] for i in 1:length(X)]



