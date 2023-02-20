using LinearAlgebra
using BlockDiagonals

n=50
k=40
d=39

A = Matrix(BlockDiagonal([zeros(1,1), ones(k,k), ones(n,n)]))

A[1,2:d+1].=1
A[2:d+1,1].=1

series = [copy(A)]

for i in 2:d+1
    
    A[1,i] = 0
    A[1,i+k] = 1

    A[i,1] = 0
    A[i+k,1] = 1
    push!(series, copy(A)) 
end

using DelimitedFiles

for i in 1:length(series)
    writedlm(string("/home/connor/Thesis/Code/Graph Series/2communities/step", i, ".csv"), series[i], ",")
end
