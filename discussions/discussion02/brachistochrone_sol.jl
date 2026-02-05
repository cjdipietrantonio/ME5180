using NLsolve
using Plots

h = 1.0
L = 1.0

#EQUATION FOR THETA
f(theta) = (theta - sin(theta)) / (1 - cos(theta)) - L/h

#SOLVE FOR THETA
res = nlsolve(x -> [f(x[1])], [2.0])     #initial guess of ~2 rad
theta_f = res.zero[1]

#COMPUTE A
r = 1 / (1 - cos(theta_f))

println("theta_f = ", theta_f)
println("r       = ", r)


#GENERATE PARAMETRIC CYCLOID
theta_s = range(0, theta_f, length=1000)
xs = r .* (theta_s .- sin.(theta_s))
ys = h .- r .* (1 .- cos.(theta_s))

plot(xs, ys,
     xlabel = "x-location (m)",
     ylabel = "y-location (m)",
     title  = "Brachistochrone Example (h=1, L=1)",
     legend = false,
     aspect_ratio = 1,
     xlims = (-0.1, L + 0.1)
)

scatter!([0, L], [h, 0], label = "Boundary points")

savefig("brachistochrone_sol.png")