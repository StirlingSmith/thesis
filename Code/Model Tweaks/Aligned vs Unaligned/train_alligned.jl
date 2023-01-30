using CSV, DataFrames, LinearAlgebra

# User needs to provide:
#   u0
#   datasize
#   tspan
#   ode_data
#   input_data_length (length of one input vector)
#   output_data_length
true_data = Matrix{Float64}(CSV.read("./Toy Example Graph/Model Tweaks/Aligned vs Unaligned/Data/Alligned.csv", DataFrame, header=0, delim=','))
dims = (8,2)
datasize = 30
ode_data = true_data[:,1:datasize]
u0 = ode_data[:,1]
tspan = (0.0f0, 10.0f0)
input_data_length = 16
output_data_length = input_data_length

include("../../_Modular Functions/constructNN.jl")
prob_neuralode, p, st = constructNN()

include("../../_Modular Functions/NODEproblem.jl")
optprob = NODEproblem()

include("../../_Modular Functions/trainNN.jl")
result = train(optprob)


temp1 = reshape(predict_neuralode(result.u), (dims...,datasize))
u0 = true_data[:,31]
temp2 = reshape(predict_neuralode(result.u), (dims...,datasize))

tempjoin = cat(temp1, temp2, dims=3)

include("../../_Modular Functions/reconstructRDPG.jl")

preds = reconstructRDPG(tempjoin)


include("../../_Modular Functions/constructKnownODEPoints.jl")
true_points = knownODEpoints()

for i in 1:60
    data = true_points[:,:,i]
    plt = scatter(data[:,1], data[:,2], color="red", legend=false)

    xaxis!(plt, lims=(-1, 1))

    dists = cat([cat([0.5*sqrt.(sum.(abs2, eachcol(data[i,:].-data[j,:]))) for j in 1:size(data)[1]]..., dims=1) for i in 1:size(data)[1]]..., dims=2)
    pred_dists = 1 .-preds
    pred_dists=pred_dists[:,:,i]
    diff_error = pred_dists./dists
    data
    line = vcat([[[(data[i,1], data[i, 2]), (diff_error[i,j]*(data[j,1]-data[i,1])+data[i,1], diff_error[i,j]*(data[j,2]-data[i,2])+data[i,2])] for j in 1:4 if j>i] for i in 1:4]...)

    for l in line
        plot!(plt,l)
    end

    display(plot(plt))
end
aligned_loss=copy(loss)

plot(log.(loss[10:end]))

##### datadriven
