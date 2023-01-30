

function train(optprob)
    result_neuralode = Optimization.solve(optprob,
    ADAM(0.005),
    callback = callback,
    maxiters = 100)

    return result_neuralode
end