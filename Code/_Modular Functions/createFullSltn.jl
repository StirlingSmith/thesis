
function createFullSltn(data, prob_neuralode, result)
    prediction = []
    for i in 1:size(data)[2]
        point_preds = []
        M = reshape(data[:,i], (dims[1],dims[2]))
        for v in 1:1
            u0 = includeKNNdists(M[v,:], M[vcat(1:mid.!=v, zeros(Bool, mid)...),:])
            pnode = remake(prob_neuralode, u0=u0)


            pred = predict_neuralode(result.u; pnode)[1:dims[2],2]
            push!(point_preds, pred)
        end
        p = hcat(point_preds...)
        push!(prediction, copy(p))
    end

    return prediction
end



# function loss(true_data, prob_neuralode, result)
#     p = createFullSln(true_data,prob_neuralode, result);
#     true_pts = [reshape(true_data[:,i], (dims...)) for i in 1:size(true_data)[2]];
#     return [sum(abs, regenerateNetwork(p[i-1]').-regenerateNetwork(true_pts[i])) for i in 2:size(true_data)[2]]
# end

# function loss(prob_neuralode, result)
#     p = createFullSln(true_data,prob_neuralode, result);
#     return [sum(abs, regenerateNetwork(p[i-1]').-time_graphs[i]) for i in 2:size(true_data)[2]]
# end

# function create_loss_plot(true_data, prob_neuralode, name="")
#     l1 = loss.([true_data], [prob_neuralode], res)
#     # l2 = loss.(prob_neuralode, res)
#     xs=1:size(true_data)[2]
#     traces1 = [scatter(x=xs, y=l1[i], name=string("Loss Embedding, Epoch ", i)) for i in eachindex(res)]
#     #traces2 = [scatter(x=xs, y=l2, name=string("Loss Real Net, Epoch ", i)) for i in eachindex(res)]
#     return (plot([traces1...]))
# end




