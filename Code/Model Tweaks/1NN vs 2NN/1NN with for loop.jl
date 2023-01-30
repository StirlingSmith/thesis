using CSV, DataFrames, LinearAlgebra
# User needs to provide:
#   u0
#   datasize
#   tspan
#   ode_data
#   input_data_length (length of one input vector)
#   output_data_length
EPOCHS = 3

# Things that are important:
# embedding dim, initial vec for SVD, amount of data

include("../../_Modular Functions/helperFunctions.jl")
include("../../_Modular Functions/loadGlobalConstants.jl")
include("../../_Modular Functions/constructNN.jl")
include("../../_Modular Functions/NODEproblem.jl")
include("../../_Modular Functions/reconstructRDPG.jl")

#u1::Array{Float32, 1} = Array{Float32, 1}(undef, output_data_length)

prob_neuralode, p, st, nn = constructNN();

optprob = NODEproblem();
res = [] # Used to store models at various training times
result::AbstractVector = []
mid = convert(Int, dims[1]/2)

TNode_data = targetNode(true_data[1:datasize],1)



#prob_neuralode = remake(prob_neuralode, u0=u0)
result = Optimization.solve(optprob,
                            ADAM(0.005),
                            callback = callback,
                            maxiters = 100)
optprob = remake(optprob, u0=result.u)
result = Optimization.solve(optprob,
                            BFGS(),
                            callback = callback,
                            maxiters = 100)
# u0 = includeKNNdists(M[v+mid,:], M[vcat(zeros(Bool, mid)...,1+mid:dims[1].!=v+mid),:])
# u1 = M̂[v+mid, :]
# prob_neuralode = remake(prob_neuralode, u0=u0)
# result = train(optprob)
# optprob = remake(optprob, u0=result.u)

# for e in 1:EPOCHS
#     println("Epoch: ", e)

#     for i in 1:datasize-1
#         M::Array{Float16, 2} = train_data[i]
#         M̂::Array{Float16, 2} =  train_data[i+1]

#         @time for v in 1:1#convert(Int, dims[1]/2)
#             # iterate over each node/point
#             u0 = includeKNNdists(M[v,:], M[vcat(1:mid.!=v, zeros(Bool, mid)...),:])
#             u1 = M̂[v, :]
#             u2 = M̂[v+convert(Int, dims[1]/2), :]
#             prob_neuralode = remake(prob_neuralode, u0=u0)
#             result = train(optprob)


#             u0 = includeKNNdists(M[v+mid,:], M[vcat(zeros(Bool, mid)...,1+mid:dims[1].!=v+mid),:])
#             u1 = M̂[v+mid, :]
#             prob_neuralode = remake(prob_neuralode, u0=u0)
#             result = train(optprob)
#             optprob = remake(optprob, u0=result.u)
            
#         end
#     end
#     push!(res, result)
#     println("")
#     println("")
# end

include("../../_Modular Functions/createFullSltn.jl")


train_data = true_data
length(train_data)
tsteps = range(1.0, 21.0, length = 21)
prob_neuralode = remake(prob_neuralode, tspan=(1.0,21.0))
sol = predict_neuralode(result.u)[:,1,:]



using DelimitedFiles

writedlm("/home/connor/Thesis/Code/Solutions/$net_name.csv", sol, ",")


