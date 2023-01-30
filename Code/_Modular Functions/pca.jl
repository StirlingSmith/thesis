using MultivariateStats

function principle_components(data; num_pcs=2)
    M = fit(PCA, Float32.(data); maxoutdim=num_pcs)
    return projection(M)
end

