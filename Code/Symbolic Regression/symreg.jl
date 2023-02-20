using SymbolicRegression
using DelimitedFiles
include("../_Modular Functions/helperFunctions.jl")
include("../_Modular Functions/loadGlobalConstants.jl")

sltn = readdlm("/home/connor/Thesis/Code/Solutions/$net_name.csv", ',')
sltnt = readdlm("/home/connor/Thesis/Code/Solutions/$net_name test only.csv", ',')
grad_sltn = sltn[:,2:end].-sltn[:,1:end-1]

trace = scatter(x=sltn[1,1:datasize*100],y=sltn[2,1:datasize*100], mode="markers")
trace2 =  scatter(x=[t_data[i][1,1] for i in 1:40],y=[t_data[i][1,2] for i in 1:40], mode="markers")
trace3 =  scatter(x=sltnt[1,1:end],y=sltnt[2,1:end], mode="markers")

plot([trace, trace2, trace3])

train_data = withoutNode(t_data,1)

function dists(u,t)
    M = reshape(train_data.A[:,Int(floor(t))],(train_data.n,train_data.d))
        
    cosine_distances = zeros(Float64, train_data.n)

    for i::Int in eachindex(cosine_distances)
        distance = sqrt(sum(abs2, M[i,:].-u)) #euclidean dist(target, node from data)
        @inbounds cosine_distances[i] = isnan(distance) ? zero(distance) : distance

    end
    return cosine_distances
end

iter_grad_sltn = [grad_sltn[:,i] for i in 1:size(grad_sltn)[2]]
data = dists.(iter_grad_sltn, 1.0:0.01:Float64(length(t_data))-0.01)
data = hcat(data...)

options = SymbolicRegression.Options(
    binary_operators=[+, *, /, -],
    npopulations=20
)

hall_of_fame1 = EquationSearch(
    data[:,1:datasize*100], grad_sltn[1,1:datasize*100], niterations=40, options=options,
    parallelism=:multithreading
)

hall_of_fame2 = EquationSearch(
    data[:,1:datasize*100], grad_sltn[2,1:datasize*100], niterations=40, options=options,
    parallelism=:multithreading
)

# hall_of_fame3 = EquationSearch(
#     train_data.A[:,1:datasize], grad_sltn[3,1:datasize], niterations=40, options=options,
#     parallelism=:multithreading
# )
dominating1 = calculate_pareto_frontier(Float64.(data), grad_sltn[1,:], hall_of_fame1, options)

dominating2 = calculate_pareto_frontier(Float64.(data), grad_sltn[2,:], hall_of_fame2, options)

#dominating3 = calculate_pareto_frontier(Float64.(train_data.A), grad_sltn[3,:], hall_of_fame3, options)


# eqn1 = node_to_symbolic(dominating1[end].tree, options)

# eqn2 = node_to_symbolic(dominating2[end].tree, options)

# eqn3 = node_to_symbolic(dominating3[end].tree, options)

sltn1 = [dominating1[end].tree(data)'; dominating2[end].tree(data)']#; dominating3[end].tree(train_data.A)']

sltn1 = [sum([sltn1[:,j]' for j in 100*(i-1)+1:100*i]) for i in 1:2*datasize-1]



sltn_sym_reg = sltn1[:, datasize+1:2*datasize-1]

collect

temp = zeros(Float64, (dims[2],datasize))
global u0 = targetNode(t_data,1)[1+datasize]'
temp[:,1].=u0

for i in 2:datasize
    temp[:,i] = temp[:,i-1]+sltn_sym_reg[:,i-1]
end

sltn_sym_reg = temp



# trace = scatter(x=sltn[1,1:datasize],y=sltn[2,1:datasize], mode="markers")
# trace2 =  scatter(x=[t_data[i][1,1] for i in 1:datasize],y=[t_data[i][1,2] for i in 1:datasize], mode="markers")
# plot([trace, trace2])