using Symbolics
using ModelingToolkit
using OrdinaryDiffEq
using Plots

# ------------------------------------------------------------------------
# Define Lagrangian System
# ------------------------------------------------------------------------

"""
    build_lagrangian_system(T, V, F_nc, q_vars, q_dots, t, params)

Automates derivation of EOMs for a physical system using Lagrangian Mechanics

# Arguments
- `T`: Symbolic expression for Kinetic Energy 
- `V`: Symbolic expression for Potential Energy
- `F_nc`: Vector of non-conservative forces
- `q_vars`: Vector of generalized coordinates
- `q_dots`: Vector of time derivatives of generalized coordinates
- `t`: time
- `params`: Vector of symbolic parameters

# Returns
- `sys`: ODESystem struct containing vector of 1st-order system of equations for each generalized coordinate and its time derivative (in addition to other objects)

"""

function build_lagrangian_system(T, V, F_nc, q_vars, q_dots, t, params)

    Lag = T - V 
    Dt = Differential(t)

    eqs = Equation[]
    for i in eachindex(q_vars)

        # Euler-Lagrange: d/dt(dL/dq_dot) - dL/dq = F_nc
        term1 = Dt(Symbolics.derivative(Lag, q_dots[i]))
        term2 = Symbolics.derivative(Lag, q_vars[i])

        # build symbolic equation
        push!(eqs, expand_derivatives(term1 - term2) ~ F_nc[i])
    end 

    @named sys = ODESystem(eqs, t, q_vars, params)
    return structural_simplify(sys)

end

# ------------------------------------------------------------------------
# Main Driver Function
# ------------------------------------------------------------------------

function main()

    # --------------------------------------------------------------------
    # Symbolic Variables and Parameters
    # --------------------------------------------------------------------

    @independent_variables t
    @variables x(t) θ(t)   
    @parameters m=0.4 L=1.0 g=9.81 k=0.1 b=0.2

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
    # Initial Conditions
    # --------------------------------------------------------------------

    u0 = [
        x => 0.0,
        θ => 0.5,
        x_dot => 0.0,
        θ_dot => 0.0
    ]

    tspan = (0.0, 25.0)
    prob = ODEProblem(sys, u0, tspan)
    sol = solve(prob, Rodas5P())

    # --------------------------------------------------------------------
    # Plot Results
    # --------------------------------------------------------------------

    p = plot(sol, idxs=θ, ylabel="Amplitude", label="θ(t)", legend=:topleft)
    plot!(p, sol, idxs=x, label="x(t)")
    xlabel!(p, "Time (s)")

    display(p)
    savefig(p, "system_results.png")

end

# ------------------------------------------------------------------------
# Main Driver Call
# ------------------------------------------------------------------------

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
