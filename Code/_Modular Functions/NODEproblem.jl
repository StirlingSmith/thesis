using Lux, DiffEqFlux, DifferentialEquations, Optimization, OptimizationOptimJL, ForwardDiff

# User needs to provide:
#   u0
#   datasize
#   tspan
#   ode_data
#   input_data_length (length of one input vector)
#   output_data_length


function predict_neuralode(θ)
  Array(solve(prob_neuralode, Tsit5(), saveat = tsteps, p = θ))
end

function loss_neuralode(θ)
    pred = predict_neuralode(θ)
    loss = sum((pred[:,1,:].-TNode_data.A).^2)
    return loss
end


callback = function(θ, l)
  #t = t+1
  #M = reshape(ode_data[:,t], (dims[1],dims[2]))
  println(l, " loss")
  return false
end

function NODEproblem()
  # Do not plot by default for the documentation
  # Users should change doplot=true to see the plots callbacks
  pinit = Lux.ComponentArray(p)

  # use Optimization.jl to solve the problem
  adtype = Optimization.AutoForwardDiff()


  optf = Optimization.OptimizationFunction((x, p) -> loss_neuralode(x), adtype)
  optprob = Optimization.OptimizationProblem(optf, pinit)
  
  return optprob
end

