using DiffEqFlux, DifferentialEquations, OptimizationOptimJL, Plots, CSV
include("/home/connor/Thesis Project/Toy Example Graph/_Modular Functions/helperFunctions.jl")
include("/home/connor/Thesis Project/Toy Example Graph/_Modular Functions/constructKnownODEPoints.jl")

ode_data_ = knownODEpoints()

rdpgs = permutedims(cat([cat([ 1.0.-0.5*sqrt.(sum.(abs2, eachcol(ode_data_[i,:,:].-ode_data_[j,:,:]))) for j in 1:size(ode_data_)[1]]..., dims=2) for i in 1:size(ode_data_)[1]]..., dims=3), (2,3,1))
# Note that this is probably a good place to check that the allignment is working
# with the svd initial vector.

temp_emb(A) = do_the_rdpg(A, 2)

slices = mapslices(temp_emb, rdpgs, dims=(1,2))
ode_data = cat([reshape([s.L̂; s.R̂], 16) for s in slices]..., dims=2)


using Tables
CSV.write("/home/connor/Thesis Project/Toy Example Graph/Graph Series/RDPG from known DE/ode_data.csv", Tables.table(ode_data), writeheader=false)







# dudt2 = Lux.Chain(x -> x,
#                   Lux.Dense(8, 50, tanh),
#                   Lux.Dense(50, 8))
# p, st = Lux.setup(rng, dudt2)
# prob_neuralode = NeuralODE(dudt2, tspan, Tsit5(), saveat = tsteps)

# function predict_neuralode(p)
#   Array(prob_neuralode(u0, p, st)[1])
# end

# function loss_neuralode(p)
#     pred = predict_neuralode(p)
#     loss = sum(abs2, ode_data .- pred)
#     return loss, pred
# end

# # Do not plot by default for the documentation
# # Users should change doplot=true to see the plots callbacks
# callback = function (p, l, pred; doplot = false)
#   println(l)
#   # plot current prediction against data
#   pred_= reshape(pred, (4,2,datasize))
#   ode_data_ = reshape(ode_data, (4,2,datasize))
#   plt = scatter(ode_data_[:,1,:], ode_data_[:,2,:], color="red", legend=false)
#   scatter!(plt, pred_[:,1,:], pred_[:,2,:], color="blue")
#   if doplot
#     display(plot(plt))
#   end
#   return false
# end

# pinit = Lux.ComponentArray(p)
# # callback(pinit, loss_neuralode(pinit)...; doplot=true)

# # use Optimization.jl to solve the problem
# adtype = Optimization.AutoZygote()

# optf = Optimization.OptimizationFunction((x, p) -> loss_neuralode(x), adtype)
# optprob = Optimization.OptimizationProblem(optf, pinit)

# result_neuralode = Optimization.solve(optprob,
#                                        ADAM(0.05),
#                                        callback = callback,
#                                        maxiters = 300)

# optprob2 = remake(optprob,u0 = result_neuralode.u)


# result_neuralode2 = Optimization.solve(optprob2,
#                                         Optim.BFGS(initial_stepnorm=0.01),
#                                         callback=callback,
#                                         allow_f_increases = false)

# callback(result_neuralode2.u, loss_neuralode(result_neuralode2.u)...; doplot=true)

# datasize=datasize*2
# tspan = (0.0f0, 20.0f0)
# tsteps = range(tspan[1], tspan[2], length = datasize)
# test_trueode = ODEProblem(trueODEfunc, u0, tspan)
# test_data = Array(solve(test_trueode, Tsit5(), saveat=tsteps))

# prob_trueode = ODEProblem(trueODEfunc, u0, tspan)
# prob_neuralode = NeuralODE(dudt2, tspan, Tsit5(), saveat = tsteps)


# function test_loss_neuralode(p)
#   pred = predict_neuralode(p)
#   loss = sum(abs2, test_data .- pred)
#   return loss, pred
# end

# test_callback = function (p, l, pred; doplot = false)
#   println(size(pred))
#   println(l)
#   # plot current prediction against data
#   pred_= reshape(pred, (4,2,datasize))
#   test_data_ = reshape(test_data, (4,2,datasize))
#   plt = scatter(test_data_[:,1,:], test_data_[:,2,:], color="red", legend=false)
#   scatter!(plt, pred_[:,1,:], pred_[:,2,:], color="blue")
#   if doplot
#     display(plot(plt))
#   end
#   return false
# end

# test_callback(result_neuralode2.u, test_loss_neuralode(result_neuralode2.u)...; doplot=true)