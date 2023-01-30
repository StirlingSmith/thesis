using Graphs
g = Graph(8)


for i in 1:4
    add_edge!(g, i, (i%4)+1)
    add_edge!(g, i+4, (i%4)+5)
end

add_edge!(g, 1, 5)

rotating_edge = [2, 6]

add_edge!(g, rotating_edge[1], rotating_edge[2])
function next_step!(g, rotating_edge)
    rem_edge!(g, rotating_edge[1], rotating_edge[2])
    new_edge = [rotating_edge[1]%4+1,rotating_edge[2]%4+5]
    if new_edge[1]==1
        new_edge[1] = new_edge[1]+1
    end
    add_edge!(g, new_edge[1], new_edge[2])
    return(new_edge)
end


time_series = Dict()

for i in 1:50
    time_series[i] = copy(g)
    println(adjacency_matrix(g))
    rotating_edge = next_step!(g, rotating_edge)
end




for i in 1:50
    savegraph(string("./Graph Series/toy_graph_", i, ".lg"), time_series[i])
end