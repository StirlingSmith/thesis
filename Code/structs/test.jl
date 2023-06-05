using DotProductGraphs

include("allignment.jl")
include("nearestNeighbours.jl")
include("constructRDPG.jl")
include("TemporalEmbedding.jl")

adj = [[0 1 1; 0 0 1; 1 0 0], [1 1 1; 0 1 1; 1 0 0], [0 1 1; 0 1 1; 1 1 0]]

TemporalNetworkEmbedding(AL=[1 2; 3 4], AR=[5 6; 7 8], n=2, d=2)
t = TemporalNetworkEmbedding(adj, 2)

t.AL
targetNode(t,3).AL
