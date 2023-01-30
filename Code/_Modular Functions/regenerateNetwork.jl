using LinearAlgebra

function regenerateNetwork(A)
    B = reshape(A, (dims[1], dims[2]))
    mid = convert(Int, dims[1]/2)
    L = B[1:mid,:]
    R = B[mid+1:end,:]
    pred_net = L*R'

    pred_net=pred_net.>0.5
    return pred_net
end