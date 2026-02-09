using Plots

#define physical constants
m = 1.0 # mass [kg]
k = 100 # spring constant [N/m]
w = sqrt(k/m) # angular frequency [1/s]

#define initial conditions
x0 = 2 # initial displacement [m]
v0 = 0 # initial velocity [m/s]

#define other condtions
T_total = 4pi / w # total simulation time [s]
t = range(0, T_total, length=5001) # time vector [s]

#define analytical solution
A = x0
B = v0/w

x_an = A .* cos.(w .* t) .+ B .* sin.(w .* t)
v_an = w .* (-A .* sin.(w .* t) .+ B .* cos.(w .* t))

#verify analytical solution
plot_x_an = plot(t, x_an,
    ylabel = "x(t) [m]",
    legend = false
)

plot_y_an = plot(t, v_an,
    xlabel = "time [s]",
    ylabel = "v(t) [m/s]",
    legend = false
)

analytical_plot = plot(plot_x_an, plot_y_an, layout=(2,1), suptitle  = "Analytical Solution")

#define general trial path
trial_paths(a) = x_an .+ a .* sin.(pi .* t ./ T_total)

#range of scalars for trial paths
a_values = range(-1, 1, length=101) 

#instantiate plot of trial paths
trial_paths_plot =plot(
    title = "Trial Paths for Mass-Spring System",
    xlabel = "time [s]",
    ylabel = "x(t) [m]",
    legend = true
)

#plot trial paths (and label only the first)

for (i, a) in enumerate(a_values)
    if i == 1
        plot!(trial_paths_plot, t, trial_paths(a), color=:gray, alpha=0.5, label="Trial Paths")
    else
        plot!(trial_paths_plot, t, trial_paths(a), color=:gray, alpha=0.3, label = nothing)
    end
end

#plot analytical solution on top
plot!(trial_paths_plot, t, x_an, color=:red, linewidth=2, label="Analytical Solution")

#compute veolcity for each path numerically (for robustness)
dt = t[2] - t[1]
trial_velocities(a) = diff(trial_paths(a)) ./ dt


#compute lagrangian for each path
L(a) = begin
    x = trial_paths(a)[1:end-1] #trim position vector to match velocity vector length, will introduce error on the order of dt
    v = trial_velocities(a)
    return 0.5 * m * v.^2 .- 0.5 * k * x.^2
end

#numerically integrate lagrangian for each trial path using rectangular rule to find action for each trial path
S(a) = sum(L(a)) * dt
S_values = [S(a) for a in a_values]

#plot action as a function of a
action_plot = plot(
    a_values,
    S_values,
    xlabel = "a (trial path scalar)",
    ylabel = "Action S(a)",
    title = "Action for Trial Paths",
    legend = false
)

i0 = findfirst(a_values .== 0)
a0 = a_values[i0]
s0 = S_values[i0]

plot!(action_plot, [a0], [s0], seriestype=:scatter, markersize=7, color=:red, label="Analytical Solution")

display(analytical_plot)
display(trial_paths_plot)
display(action_plot)

savefig(analytical_plot, "analytical_solution.png")
savefig(trial_paths_plot, "trial_paths.png")
savefig(action_plot, "action_plot.png")

