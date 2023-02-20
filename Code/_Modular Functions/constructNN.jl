using Lux, Random

include("convertToDistances.jl")
include("helperFunctions.jl")



function constructNN()
    # x is the point vector we are trying to predict
    # i is the index of the point we are trying to predict 
    rng = Random.default_rng()
    nn = Lux.Chain((x) -> x,
          Lux.Dense(input_data_length, 32, tanh),
          Lux.Dense(32, 8),
          Lux.Dense(8, output_data_length))

    p, st = Lux.setup(rng, nn)
    
    function dudt_pred(du,u,p,t)
      # This is the function that is not working
      M = reshape(train_data.A[:,Int(floor(t))],(train_data.n,train_data.d))
      
      cosine_distances = zeros(Float64, train_data.n)
      
      for i::Int in eachindex(cosine_distances)
          distance = sqrt(sum(abs2, M[i,:].-u)) #euclidean dist(target, node from data)
          if typeof(distance) == Float32
            @inbounds cosine_distances[i] = isnan(distance) ? zero(distance) : distance
          else
            @inbounds cosine_distances[i] = isnan(distance.value) ? zero(distance.value) : distance.value
          end
      end
      û = partialsort(cosine_distances,1:k, by=x->x)

      du .= nn(û, p, st)[1]
    end
    
    prob_neuralode = ODEProblem{true}(dudt_pred, u0, tspan)
    return prob_neuralode,p,st,nn
end
