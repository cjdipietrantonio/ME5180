using NLsolve
using Plots

h = 1.0
L = 1.0

#EQUATION FOR THETA
f(theta) = (0 - sin(0)) / (1 - cos(0)) - L

#SOLVE FOR THETA
res = nlsolve(x -> [f(x[1]), [2.0]])     #initial guess of ~2 rad
theta_f = res.zero[1]

#COMPUTE A
a = 1 / (1 - cos(theta_f))

println("theta_f = ", theta_f)
println("a       = ", a)


#GENERATE PARAMETRIC CYCLOID
theta_s = range(0, theta_f, length=1000)
xs = a .* (theta_s .- sin.(theta_s))
ys = h .- a .* (1 .- cos.(theta_s))

plot(xs, ys,
     xlabel = "x",
     ylabel = "y",
     title  = "Brachistochrone (h=1, L=1)",
     legend = false,
     aspect_ratio = 1
)

scatter!([0, L], [h, 0], label = "Boundary points")