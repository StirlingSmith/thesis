using LinearAlgebra
using BlockDiagonals


n=50
k=10

dv = zeros(Int, n)
ev = ones(Int, n-1)

T = Matrix(SymTridiagonal(dv, ev))

A = Matrix(BlockDiagonal([zeros(1,1), ones(k,k), T]))


A[1,k+2]=1
A[k+1,k+2]=1

A[k+2,1]=1
A[k+2,k+1]=1

series = [copy(A)]

for i in 2:n
    
    A[1,i+k] = 0
    A[1,i+k+1] = 1

    A[i+k,1] = 0
    A[i+k+1,1] = 1
    push!(series, copy(A)) 
end

series[1]

using DelimitedFiles

for i in 1:length(series)
    writedlm(string("/home/connor/Thesis/Code/Toy Example Graph/Graph Series/longTailSmallBlob/step", i, ".csv"), series[i], ",")
end
