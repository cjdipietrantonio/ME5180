using Symbolics, Plots, NonlinearSolve, ModelingToolkit
using ModelingToolkit: t_nounits as t, D_nounits as D

q = @variables x₁, y₁, θ₁, x₂, y₂, θ₂, x₃, y₃, θ₃, x₄, y₄, θ₄
L2 = 0.15     # crank arm length [m]
L3 = 0.35     # connecting rod length [m]
ω = 150       # angular velocity [rad/s]
θ₀ = 0        # initial crank angle [rad]

function main()
    # ------------------------------------------------------------
    # System parameters (matching Shabana Ch. 3 / notebook)
    # ------------------------------------------------------------
    q = @variables x₁, y₁, θ₁, x₂, y₂, θ₂, x₃, y₃, θ₃, x₄, y₄, θ₄
    L2 = 0.15    # crank arm length [m]
    L3 = 0.35    # connecting rod length [m]
    ω  = 150     # angular velocity [rad/s]
    θ₀ = 0       # initial crank angle [rad]

    # ------------------------------------------------------------
    # 12 constraint equations for 4 bodies (12 DOFs)
    # ------------------------------------------------------------
    C(q, t) = [
        q[1] - 0;                                           # ground x
        q[2] - 0;                                           # ground y
        q[3] - 0;                                           # ground θ
        q[4] - L2/2*cos(q[6]) - q[1];                      # crank-ground pin (x)
        q[5] - L2/2*sin(q[6]) - q[2];                      # crank-ground pin (y)
        q[7] - L3/2*cos(q[9]) - q[4] - L2/2*cos(q[6]);    # rod-crank pin (x)
        q[8] - L3/2*sin(q[9]) - q[5] - L2/2*sin(q[6]);    # rod-crank pin (y)
        q[10] - q[7] - L3/2*cos(q[9]);                     # piston-rod pin (x)
        q[11] - q[8] - L3/2*sin(q[9]);                     # piston-rod pin (y)
        q[11] - 0;                                          # piston slides on y=0
        q[12] - 0;                                          # piston no rotation
        q[6] - ω*t - θ₀                                    # prescribed crank rotation
    ]

    # Jacobian C_q and partial C_t (for velocity solve)
    dCdq(q, t) = Symbolics.jacobian(C(q, t), q)
    partialCt  = Symbolics.derivative.(C(q, t), t)

    # ------------------------------------------------------------
    # Solve over one full crank rotation
    # ------------------------------------------------------------
    N  = 200
    tN = LinRange(0, 2π / ω, N)

    q_sol  = zeros(length(tN), 12)
    dq_sol = zeros(length(tN), 12)

    # initial guess: everything aligned along x-axis at t=0
    u0 = [0, 0, 0, L2/2, 0, 0, L2 + L3/2, 0, 0, L2 + L3, 0, 0]

    # Build the nonlinear system once
    eqs = 0 .~ C(q, t)
    @named constraint_system = NonlinearSystem(eqs, q, [t])
    constraint_system = complete(constraint_system)

    for (i, t0) in enumerate(tN)
        # Step 1: solve for positions  C(q, t) = 0
        initial_guess = Dict(q[j] => u0[j] for j in 1:12)
        problem = NonlinearProblem(
            constraint_system,
            merge(initial_guess, Dict(t => t0))
        )
        solution = solve(problem)
        u0 = solution.u
        q_sol[i, :] = solution.u

        # Step 2: solve for velocities  C_q · dq = -C_t
        sol_dict = Dict(q[j] => q_sol[i, j] for j in 1:12)
        Cq_num = Symbolics.substitute(dCdq(q, t0), sol_dict, fold = Val(true))
        Ct_num = Symbolics.substitute(-partialCt, sol_dict, fold = Val(true))
        dq_sol[i, :] = Symbolics.value.(Cq_num \ Ct_num)
    end

    # ------------------------------------------------------------
    # Shabana verification plots (4 plots vs crank angle in rad)
    # ------------------------------------------------------------
    crank_angle = q_sol[:, 6]   # θ² in radians

    # --- Position level ---
    p1 = plot(crank_angle, q_sol[:, 9],
        xlabel = "Crank angle θ² (rad)", ylabel = "θ³ (rad)",
        title  = "Orientation of the connecting rod",
        lw = 2, legend = false, color = :blue)

    p2 = plot(crank_angle, q_sol[:, 10],
        xlabel = "Crank angle θ² (rad)", ylabel = "x⁴ (m)",
        title  = "Displacement of the slider block",
        lw = 2, legend = false, color = :red)

    # --- Velocity level ---
    p3 = plot(crank_angle, dq_sol[:, 9],
        xlabel = "Crank angle θ² (rad)", ylabel = "dθ³/dt (rad/s)",
        title  = "Angular velocity of the connecting rod",
        lw = 2, legend = false, color = :blue)

    p4 = plot(crank_angle, dq_sol[:, 10],
        xlabel = "Crank angle θ² (rad)", ylabel = "dx⁴/dt (m/s)",
        title  = "Velocity of the slider block",
        lw = 2, legend = false, color = :red)

    # --- Combined 2×2 layout ---
    p_combined = plot(p1, p2, p3, p4,
        layout = (2, 2), size = (800, 600), margin = 5Plots.mm)
    savefig(p_combined, "shabana_verification.png")
    println("Plots saved to shabana_verification.png")

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end