using PlotlyJS
using ColorSchemes
include("../_Modular Functions/pca.jl")
include("../_Modular Functions/loadGlobalConstants.jl")


function get_embedding(B, pred)
    println(size(B))
    mid = convert(Int, dims[1]/2)
    L = B[1:mid,:]

    if dims[2] > 2
        return principle_components([pred'; L])
    else
        return [pred'; L]
    end
end

using DelimitedFiles


sltn = readdlm("/home/connor/Thesis/Code/Solutions/$net_name.csv", ',')


for i in 1:21
    pts = get_embedding(true_data[i], sltn[:,i])
    traces0 = scatter(x=[pts[1,1]+0.01], y=[pts[1,2]], name="Pred")
    traces1 = scatter(x=[pts[2,1]+0.01], y=[pts[2,2]], name="Focus")
    traces2 = scatter(x=pts[3:42,1], y=pts[3:42,2], mode="markers", name="k group")
    traces3 = scatter(x=pts[43:end,1], y=pts[43:end,2], mode="markers", name="n group")
    display(plot([traces0, traces1, traces2, traces3]))
end
