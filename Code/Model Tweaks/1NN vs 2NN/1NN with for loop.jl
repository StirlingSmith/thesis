using CSV, DataFrames, LinearAlgebra, Revise
# User needs to provide:
#   u0
#   datasize
#   tspan
#   ode_data
#   input_data_length (length of one input vector)
#   output_data_length

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

TNode_data = targetNode(t_data[1:datasize],1)



#prob_neuralode = remake(prob_neuralode, u0=u0)
result = Optimization.solve(optprob,
                            ADAM(0.001),
                            callback = callback,
                            maxiters = 300)
optprob = remake(optprob, u0=result.u)
result = Optimization.solve(optprob,
                            Optim.BFGS(initial_stepnorm=0.01),
                            callback = callback,
                            maxiters = 100)
optprob = remake(optprob, u0=result.u)
# println("Part 2")
# result = Optimization.solve(optprob,
#                             BFGS(),
#                             callback = callback,
#                             maxiters = 25)
# optprob = remake(optprob, u0=result.u)
println("Done")
                            

include("../../_Modular Functions/createFullSltn.jl")

global train_data = withoutNode(t_data,1)
tsteps = range(1.0, Float64(length(t_data)), length = length(t_data))
prob_neuralode = remake(prob_neuralode, tspan=(1.0,Float64(length(t_data))))
function predict_neuralode(θ)
    Array(solve(prob_neuralode, Tsit5(), saveat = 0.01, p = θ))
end
# prob_neuralode, p, st, nn = constructNN();
# optprob = NODEproblem();
sol = predict_neuralode(result.u)[:,1,:]

using DelimitedFiles

writedlm("/home/connor/Thesis/Code/Solutions/$net_name.csv", sol, ",")

function predict_neuralode(θ)
    Array(solve(prob_neuralode, Tsit5(), saveat = tsteps, p = θ))
  end
  
global train_data = withoutNode(t_data[1+datasize:end],1)
global u0 = targetNode(t_data,1)[1+datasize]'
global tspan = (1.0, 10.0)
global tsteps = range(tspan[1], tspan[2], length = datasize)
prob_neuralode, p, st, nn = constructNN();
optprob = NODEproblem();
sol = predict_neuralode(result.u)[:,1,:]

using DelimitedFiles

writedlm("/home/connor/Thesis/Code/Solutions/$net_name test only.csv", sol, ",")


