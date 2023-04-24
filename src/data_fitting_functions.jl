#= SPECIFIC FUNCTIONS FOR LEAST-SQUARES SPLINE FITTING: =#

function manipulate_knot_coordinates!(knot_coordinates, q)
    N_knot = size(knot_coordinates,1)
    q_first = sort(view(q,1:N_knot-2))
    q_last = view(q,N_knot-1:2*N_knot-2)
    knot_coordinates[1,2] = q_last[1]
    for i = 1 : N_knot-2
        knot_coordinates[1+i,1] = q_first[i]
        knot_coordinates[1+i,2] = q_last[i+1]
    end
    knot_coordinates[N_knot,2] = q_last[N_knot]
end

function χ2(knot_coordinates, X, Y, σ, q)
    N = length(X)
    manipulate_knot_coordinates!(knot_coordinates, q)
    spline_parameters = make_spline_parameters(knot_coordinates)
    χ2 = 0.0
    for n = 1 : N
        χ2 += ( Y[n] - spline(X[n],spline_parameters) )^2 / σ[n]^2
    end
    return χ2/N
end

function fit_spline(N_knot, X, Y, σ, msteps=1000000, mode=:silent, psize=50, tint=1.0)
    X_init = X[1]
    X_end = X[end]
    knot_coordinates = zeros(N_knot,2)
    knot_coordinates[1,1] = X_init#*0.8 # We choose the fixed end knots slightly outside of the data range
    knot_coordinates[N_knot,1] = X_end#*1.25
    result = bboptimize(q->χ2(knot_coordinates, X, Y, σ, q);
        SearchRange = vcat([ [(X_init,X_end) for i = 1 : N_knot-2], [(-100.0,100.0) for i = 1 : N_knot] ]...),
        MaxSteps = msteps, 
        TraceMode = mode, 
        PopulationSize = psize, 
        TraceInterval = tint) # optimization performed using BlackBoxOptim package
    spline_parameters = make_spline_parameters(knot_coordinates)
    return best_fitness(result), spline_parameters
end

BIC(χ2_norm, N_knot, M) = 2*(N_knot-2)*log(M)/M + χ2_norm # Here, M denotes number of data points

function find_best_model(X, Y, σ, N_knot=collect(2:10), msteps=1000000, mode=:silent, psize=50, tint=10.0)
    N = length(N_knot)
    M = length(X)
    bic = zeros(N)
    p = Progress(N, 1)
    @threads for n = 1 : N
        χ2_norm, spline_parameters = fit_spline(N_knot[n], X, Y, σ, msteps, mode, psize, tint)
        bic[n] = BIC(χ2_norm, N_knot[n], M)
        next!(p)
    end
    return bic
end

function fit_data(data, N_max=10, msteps=1000000, mode=:silent, psize=50, tint=10.0)
    N_knot = collect(2:N_max)
    M = size(data,1)
    d = size(data,2)
    if d < 2 || d > 3
        return @warn "DATA does not have proper format, i.e., columns of 'temperature', 'ln(K)', and 'uncertainties' (the last column is optional)."
    end
    if d == 2
        data = hcat([data, ones(M)]...)
    end
    println("Finding best linear model...")
    X_linear = view(data,:,1)
    Y_linear = view(data,:,2)
    σ_linear = view(data,:,3)
    bic_linear = find_best_model(X_linear, Y_linear, σ_linear)
    println("Finding best reciprocal model...")
    X_reciprocal = 1 ./ view(data,M:-1:1,1)
    Y_reciprocal = view(data,M:-1:1,2)
    σ_reciprocal = view(data,M:-1:1,3)
    bic_reciprocal = find_best_model(X_reciprocal, Y_reciprocal, σ_reciprocal)
    if minimum(bic_linear) < minimum(bic_reciprocal)
        n = findmin(bic_linear)[2]
        χ2_norm, spline_parameters = fit_spline(N_knot[n], X_linear, Y_linear, σ_linear)
        println(string("Best model is linear with ", N_knot[n], " spline knots."))
        return "linear", spline_parameters
    else
        n = findmin(bic_reciprocal)[2]
        χ2_norm, spline_parameters = fit_spline(N_knot[n], X_reciprocal, Y_reciprocal, σ_reciprocal)
        println(string("Best model is reciprocal with ", N_knot[n], " spline knots."))
        return "reciprocal", spline_parameters
    end
end
