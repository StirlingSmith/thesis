using CSV, DataFrames, LinearAlgebra, PlotlyJS

# User needs to provide:
#   u0
#   datasize
#   tspan
#   ode_data
#   input_data_length (length of one input vector)
#   output_data_length
true_data = Matrix{Float64}(CSV.read("./Model Tweaks/Aligned vs Unaligned/Data/Unaligned.csv", DataFrame, header=0, delim=','))
datasize = 30
ode_data = true_data[:,1:datasize]
u0 = ode_data[:,1]
tspan = (0.0f0, 10.0f0)
input_data_length = 16
output_data_length = input_data_length



include("../../NN_prototyper.jl")




result_neuralode = Optimization.solve(optprob,
                                       ADAM(0.05),
                                       callback = callback,
                                       maxiters = 300)

optprob2 = remake(optprob,u0 = result_neuralode.u)

result_neuralode2 = Optimization.solve(optprob2,
                                        Optim.BFGS(initial_stepnorm=0.01),
                                        callback=callback,
                                        allow_f_increases = false)


temp = reshape(predict_neuralode(result_neuralode2.u), (8,2,datasize))

mult(A) = A[1:4,:]*A[5:8,:]'
preds = mapslices(mult, temp, dims=(1,2))

u0 = true_data[:,31]
temp = reshape(predict_neuralode(result_neuralode2.u), (8,2,datasize))
preds = cat(preds,mapslices(mult, temp, dims=(1,2)), dims=3)

u0=[0.5 0.5;
    0.125 -0.125;
    -0.5 0.0;
    -0.5 -0.5]
u0=reshape(u0, 8)
test_size = 60
tspan = (0.0f0, 20.0f0)
tsteps = range(tspan[1], tspan[2], length = test_size)


function trueODEfunc(du, u, p, t)
  u_ = reshape(u, (4,2))
  du_ = reshape(du, (4,2))
  du_ = (sum.(abs2, eachrow(u_)).-0.25).*[u_[:,2] -u_[:,1]]
  du .= reshape(du_, 8)
end

prob_trueode = ODEProblem(trueODEfunc, u0, tspan)
true_points= Array(solve(prob_trueode, Tsit5(), saveat = tsteps))



for i in 1:test_size
    data = reshape(true_points[:,i], (4,2))
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

unaligned_loss = copy(loss)

trace1 = PlotlyJS.scatter(x=1:length(aligned_loss), y=log10.(aligned_loss), mode="line", name="Aligned")
trace2 = PlotlyJS.scatter(x=1:length(unaligned_loss), y=log10.(unaligned_loss), mode="line", name="Unaligned")
PlotlyJS.plot([trace1,trace2], Layout(title="DRAFT Aligned vs Unaligned Loss"))
trace1
##### datadriven
scatter()