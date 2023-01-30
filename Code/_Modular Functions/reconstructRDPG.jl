using LinearAlgebra
function reconstructRDPG(data)
    # Takes a (2n, d, datasize) tensor and outputs a (n,n,datasize) tensor were
    # (:,:,i) is RDPG at time i
    split = Int(dims[1]/2)
    mult(A) = A[1:split,:]*A[split+1:end,:]'
    mapslices(mult, data, dims=(1,2))
end
