using Lux, Random

include("convertToDistances.jl")
include("helperFunctions.jl")



function constructNN()
    # x is the point vector we are trying to predict
    # i is the index of the point we are trying to predict
    

    
    rng = Random.default_rng()
    nn = Lux.Chain((x) -> x,
          Lux.Dense(input_data_length, 16, tanh),
          Lux.Dense(16, output_data_length))

    p, st = Lux.setup(rng, nn)

    
    function dudt_pred(du,u,p,t)
      M = train_data.A[:,Int(floor(3))]
      # println("M: ",size(M))
      cosine_distances = zeros(Float64, train_data.n)
    
      for i::Int in eachindex(cosine_distances)
          indeces = [1 + j*train_data.n for j in 0:train_data.d-1]
          distance::Float64 = collect(M[indeces]'*u0)[1]# - dot(u, M[i,:]) #/ (norm(u) * norm(M[indeces])) #cosine_dist(u, M[indeces]) 
          cosine_distances[i] = isnan(distance) ? zero(distance) : distance
          #@inbounds 
      end
      û = partialsort(cosine_distances,1:k, by=x->x)

      du .= nn(û, p, st)[1]
    end
    
    prob_neuralode = ODEProblem{true}(dudt_pred, u0, tspan)
    return prob_neuralode,p,st,nn
end

