global dims=(182,2)   
global net_name = "2communities"
include("load2ComGraphFlat.jl")
include("../structs/TemporalEmbedding.jl")
global true_data, time_graphs = load2ComGraphFlat();
true_data = TemporalNetworkEmbedding(round.(true_data, digits=10),dims[1],dims[2])


global datasize = 10
global const train_data = withoutNode(true_data[1:datasize],1)
global test_data = true_data[1+datasize:end]
global tspan = (1.0, 10.0)
global tsteps = range(tspan[1], tspan[2], length = datasize)
global k = 20

global input_data_length = k
global output_data_length = dims[2]

global u0 = targetNode(true_data,1)[1]'

