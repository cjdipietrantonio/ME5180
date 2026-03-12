include("../discussion06/discussion06.jl")

using Symbolics
using ModelingToolkit
using OrdinaryDiffEq
using Plots
using Statistics

function main()

    # --------------------------------------------------------------------
    # Symbolic Variables and Parameters
    # --------------------------------------------------------------------

    @independent_variables t
    @variables x(t) θ(t)   
    @parameters m=0.1 L=0.9 g=9.81 k=0.1 b=5.0

    Dt = Differential(t)
    x_dot = Dt(x)
    θ_dot = Dt(θ)

    # --------------------------------------------------------------------
    # Kinematics & Energies
    # --------------------------------------------------------------------

    T = 0.5 * m * (x_dot^2 + (L^2 * θ_dot^2 / 3) + L * x_dot * θ_dot * cos(θ))
    V = 0.5 * k * x^2 + m * g * (L/2) * (1 - cos(θ))

    F_nc = [-b * x_dot, 0]
    q_vars = [x, θ]
    q_dots = [x_dot, θ_dot]
    params = [m, L, g, k, b]

    sys = build_lagrangian_system(T, V, F_nc, q_vars, q_dots, t, params)

    # --------------------------------------------------------------------
    # Parameter Sweep
    # --------------------------------------------------------------------

    b_vals = range(0.2, 0.4, length = 100)
    k_vals = range(0.2, 0.4, length = 100)

    u0 = [
        x => 0.0,
        θ => π/3,
        x_dot => 0.0,
        θ_dot => 0.0
    ]

    tspan = (0.0, 25.0)

    best_score = Inf
    best_b = 0.0
    best_k = 0.0

    scores = zeros(length(b_vals), length(k_vals))

    base_prob = ODEProblem(sys, u0, tspan)

    for (i, b_val) in enumerate(b_vals)
        for (j, k_val) in enumerate(k_vals)
            params_new = [k=>k_val, b=>b_val]
            #prob = ODEProblem(sys, u0, tspan, p)
            prob = remake(base_prob; p=params_new)
            sol = solve(prob, Rodas5P())

            #score = sum(sol[θ] .^2 )
            
            θ_history = sol[θ]
            settled = findlast(abs.(θ_history) .> 0.01)
            score = settled === nothing ? Inf : sol.t[settled]

            scores[i, j] = score

            if score < best_score
                best_score = score
                best_b = b_val
                best_k = k_val
            end
        end
    end

    println("Optimal b: $best_b kg/s")
    println("Optimal k: $best_k N/m")

    # --------------------------------------------------------------------
    # Plot 1 - Heatmap
    # --------------------------------------------------------------------

    hmap = heatmap(k_vals, b_vals, scores,
                   xlabel = "Spring stiffness k (N/m)",
                   ylabel = "Damping coefficient b (kg/s)",
                   title   = "Pendulum motion score",
                   c       = :viridis)

    scatter!(hmap, [best_k], [best_b],
             marker = :star5,
             markersize = 10,
             color      = :white,
             label      = "Optimum (b=$(round(best_b, digits=2)), k=$(round(best_k, digits=2)))")

    display(hmap)
    savefig(hmap, "optimum.png")

    println("Max Score: ", maximum(scores))
    println("Median Score: ", median(scores))
    println("Min Score: ", minimum(scores))

    # --------------------------------------------------------------------
    # Plot 2 - Response Comparison
    # --------------------------------------------------------------------

    p2 = plot(
              xlabel = "Time (s)",
              ylabel = "θ (rad)",
              title = "Pendulum Angle vs Time",
              legend = :topright
    )

    colors = [:purple, :green]

    cases = [
        (best_b, best_k, "Optimum (b=$(round(best_b, digits=2)), k=$(round(best_k, digits=2)))"),
        (5.0, 2.0, "Notebook default (b=5, k=2)"),
        (0.5, 2.0, "Low damping (b=0.5, k=2)"),
        #(100.0, 2.0, "High damping (b=100, k=2)")
    ]

    for (i, (b_val, k_val, label)) in enumerate(cases)
        params_new = [k=>k_val, b=>b_val]
        prob = remake(base_prob; p=params_new)
        sol = solve(prob, Rodas5P())

        if i == 1
            plot!(p2, sol.t, sol[θ], label=label, lw=4, color=:red, linestyle=:solid)
        else
            plot!(p2, sol.t, sol[θ], label=label, lw=2, color=colors[i-1], linestyle=:dash)
        end

    end

    display(p2)
    savefig(p2, "time_history.png")

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end