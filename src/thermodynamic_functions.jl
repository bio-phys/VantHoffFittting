#= SPECIFIC FUNCTIONS FOR THERMODYNAMIC POTENTIALS: =#

const R = 8.3145e-3 # kJ mol^-1 K^-1

function ln_K(x, spline_parameters, model)
    if model == "linear"
        return spline(x,spline_parameters)
    elseif model == "reciprocal"
        return spline(1/x,spline_parameters)
    else
        return @warn string("argument '", model, "' is not a defined model")
    end
end

function ΔG(T, spline_parameters, model)
    ln_K(x) = spline(x,spline_parameters)
    if model == "linear"
        return -R*T*ln_K(T) # kJ mol^-1
    elseif model == "reciprocal"
        return -R*T*ln_K(1/T) # kJ mol^-1
    else
        return @warn string("argument '", model, "' is not a defined model")
    end
end

function ΔH(T, spline_parameters, model)
    dln_K(x) = d_spline(x,spline_parameters)
    if model == "linear"
        return R*T^2*dln_K(T) # kJ mol^-1
    elseif model == "reciprocal"
        return -R*dln_K(1/T) # kJ mol^-1
    else
        return @warn string("argument '", model, "' is not a defined model")
    end
end

function ΔS(T, spline_parameters, model)
    if model == "linear"
        return (ΔH(T, spline_parameters, model) - ΔG(T, spline_parameters, model))/T # kJ mol^-1 K^-1
    elseif model == "reciprocal"
        return (ΔH(T, spline_parameters, model) - ΔG(T, spline_parameters, model))/T # kJ mol^-1 K^-1
    else
        return @warn string("argument '", model, "' is not a defined model")
    end
end

function ΔC_p(T, spline_parameters, model)
    dln_K(x) = d_spline(x,spline_parameters)
    ddln_K(x) = dd_spline(x,spline_parameters)
    if model == "linear"
        return 2*R*T*dln_K(T) + R*T^2*ddln_K(T) # kJ mol^-1
    elseif model == "reciprocal"
        return R/T^2*ddln_K(1/T) # kJ mol^-1
    else
        return @warn string("argument '", model, "' is not a defined model")
    end
end
