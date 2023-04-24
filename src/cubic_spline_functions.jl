#= GENERAL FUNCTIONS NEEDED TO CONSTRUCT CUBIC SPLINES: =#

function make_spline_parameters(knot_coordinates) # output format: S_0 - S_1 - S_2 - S_3 - x_0 (knot positions)
    N = size(knot_coordinates,1)
    a = knot_coordinates[:,2]
    b = zeros(N)
    c = zeros(N+1)
    d = zeros(N)
    l = ones(N+1)
    μ = zeros(N+1)
    z = zeros(N+1)
    h = [ knot_coordinates[n+1,1] - knot_coordinates[n,1] for n = 1 : N-1 ]
    for i = 2 : N-1
        l[i] = 2.0*(h[i] + h[i-1]) - h[i-1]*μ[i-1]
        μ[i] = h[i]/l[i]
        z[i] = (3.0*(a[i+1] - a[i])/h[i] - 3.0*(a[i] - a[i-1])/h[i-1] - h[i-1]*z[i-1])/l[i]
    end
    for i = 2 : N
        c[N+1-i] = z[N+1-i] - μ[N+1-i]*c[N+2-i]
        b[N+1-i] = (a[N+2-i] - a[N+1-i])/h[N+1-i] - h[N+1-i]*(c[N+2-i] + 2.0*c[N+1-i])/3.0
        d[N+1-i] = (c[N+2-i] - c[N+1-i])/(3.0*h[N+1-i])
    end
    return hcat([view(a,1:N),b,view(c,1:N),d,view(knot_coordinates,1:N,1)]...) # spline_parameters
end

function spline(x,spline_parameters)
    x_0 = view(spline_parameters,:,5)
    i = searchsortedfirst(x_0[2:length(x_0)-1],x)
    S_0 = spline_parameters[i,1]
    S_1 = spline_parameters[i,2]
    S_2 = spline_parameters[i,3]
    S_3 = spline_parameters[i,4]
    return S_0 + S_1*(x - x_0[i]) + S_2*(x - x_0[i])^2 + S_3*(x - x_0[i])^3
end

function d_spline(x,spline_parameters)
    x_0 = view(spline_parameters,:,5)
    i = searchsortedfirst(x_0[2:length(x_0)-1],x)
    S_1 = spline_parameters[i,2]
    S_2 = spline_parameters[i,3]
    S_3 = spline_parameters[i,4]
    return S_1 + 2*S_2*(x - x_0[i]) + 3*S_3*(x - x_0[i])^2
end

function dd_spline(x,spline_parameters)
    x_0 = view(spline_parameters,:,5)
    i = searchsortedfirst(x_0[2:length(x_0)-1],x)
    S_2 = spline_parameters[i,3]
    S_3 = spline_parameters[i,4]
    return 2*S_2 + 6*S_3*(x - x_0[i])
end
