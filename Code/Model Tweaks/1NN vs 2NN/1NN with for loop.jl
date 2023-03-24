using CSV, DataFrames, LinearAlgebra, Revise, CUDA
using DifferentialEquations, Lux, SciMLSensitivity, ComponentArrays
# CUDA.allowscalar(false)
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


rng = Random.default_rng()
nn = Lux.Chain(x -> x,
      Lux.Dense(input_data_length, 32, tanh),
      Lux.Dense(32, 8),
      Lux.Dense(8, 4),
      Lux.Dense(4, output_data_length))

p, st = Lux.setup(rng, nn)

p = p |> ComponentArray #|> Lux.gpu
# st = st |> Lux.gpu


function dudt_pred(u,p,t) 

  M = train_data[t]

  subtract_func(m) = m-u
  direction_vecs = [subtract_func(m) for m in eachcol(M)]

  û = vcat(partialsort(direction_vecs,1:k, by=x->sum(abs2, x))...)
  nn(û, p, st)
end

dudt_pred_(u,p,t) = dudt_pred(u,p,t)[1]

prob_neuralode = ODEProblem{false}(dudt_pred_, u0, tspan, p)

# prob_neuralode, p, st, nn = constructNN();



# optprob = NODEproblem();
  # use Optimization.jl to solve the problem
adtype = Optimization.AutoForwardDiff()


optf = Optimization.OptimizationFunction((x,p)->loss_neuralode(x), adtype)
optprob = Optimization.OptimizationProblem(optf, p)
optprob = remake(optprob, u0=result.u)
res = [] # Used to store models at various training times
#result::AbstractVector = []
mid = convert(Int, dims[1]/2)

TNode_data = targetNode(t_data[1:datasize],1)


#prob_neuralode = remake(prob_neuralode, u0=u0)
result = Optimization.solve(optprob,
                            ADAM(0.005),
                            callback = callback,
                            maxiters = 600)
optprob = remake(optprob, u0=result.u)

result = Optimization.solve(optprob,
                            Optim.BFGS(initial_stepnorm=0.001),
                            callback = callback,
                            maxiters = 200)
optprob = remake(optprob, u0=result.u)
# println("Part 2")
# result = Optimization.solve(optprob,
#                             BFGS(),
#                             callback = callback,
#                             maxiters = 25)
# optprob = remake(optprob, u0=result.u)
println("Done")
                            

#include("../../_Modular Functions/createFullSltn.jl")

global train_data = withoutNode(t_data,1)
global tsteps = range(1.0, Float64(length(t_data)), length = 100*length(t_data))
prob_neuralode = ODEProblem{false}(dudt_pred_, u0, tspan, p)
prob_neuralode = remake(prob_neuralode, tspan=(1.0,Float64(length(t_data))))
function predict_neuralode(θ)
  Array(solve(prob_neuralode, Tsit5(), saveat = tsteps, p=θ))#|>Lux.gpu
end
# prob_neuralode, p, st, nn = constructNN();
# optprob = NODEproblem();
sol = predict_neuralode(result.u)

# loss_neuralode(result.u)
using DelimitedFiles

writedlm("./Code/Solutions/$net_name.csv", sol, ",")

function predict_neuralode(θ)
  Array(solve(prob_neuralode, Tsit5(), saveat = tsteps, p=θ))#|>Lux.gpu
end
  
global train_data = withoutNode(t_data[1+datasize:end],1)
global u0 = vec(targetNode(t_data,1)[1+datasize])
global tspan = (1.0, Float64(length(t_data[1+datasize:end])))
global tsteps = range(tspan[1], tspan[2], length = length(train_data))
prob_neuralode = ODEProblem{false}(dudt_pred_, u0, tspan, p)
optprob = NODEproblem();
sol = predict_neuralode(result.u)

using DelimitedFiles

writedlm("./Code/Solutions/$net_name test only.csv", sol, ",")


