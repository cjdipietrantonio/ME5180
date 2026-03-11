Christian DiPietrantonio
ME5180
Discussion 06
03/10/2026

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Prompt: 

[Rigid body motion with non-conservative forces](https://cooperrc.github.io/dynamics/tutorials/09_damped-pendulum/)

In this video, I build the Lagrange equations of motion for a pendulum that is damped at its support. In the [Pluto notebook](https://cooperrc.github.io/dynamics/tutorials/09_damped-pendulum.jl), I start to create the Symbolic equations of motion with the variational equations derived in the video.

Are you able to create a set of differential equations in Julia with this set up? Can we build a general solver that goes from:

1. $L = T-V$

2. eqs = $\frac{d}{dt} \left( \frac{\partial L}{\partial \dot{q}} \right) - \frac{\partial L}{\partial q} - F_q  = 0$

3. `ode_solver(eqs)`

to plots and figures?

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Response:

After watching the lecture, it was pretty clear that deriving EOMs for every generalized coordinate using the Euler-Lagrange method can be super tedious (especially for cases with a ton of generalized coordinates). So I decided to make a function that does it for me. The code below defines a function that takes the following inputs:
- Expressions for the kinetic and potential energy ($T$ and $V$)
- A vector of non-conservative forces $(\vec{F_q})$
- Vectors for generalized coordinates ($\vec{q}$) and their time derivatives $(\dot{\vec{q}})$
- A symbolic variable for time $(t)$
- A vector of symbolic parameters

The function uses the Euler-Lagrange equation to build a symbolic equation for each generalized coordinate. It then converts the 2nd-order equations into a 1st-order system, which is returned as an `ODESystem` struct, `sys`. 

In the main driver, parameters for a physical system (the compound pendulum shown in the lecture) are defined and passed into the `build_lagrangian_system()` function as an example. The resulting `sys` struct is then passed to the `ODEProblem()` function along with the initial conditions and time span of the system. The result of this (`prob` struct) is then passed to the `solve()` function, which returns the `sol` struct. From this, the state-vector data can be accessed for plotting/further analysis. For this system, the following plot was created for proof of concept:

<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/discussions/discussion06/system_results.png?raw=true"
    width="500">
</p>

Which shows both $\theta$ and $x$ decaying to equilibrium as energy is dissipated through the damper, as expected.

Overall, defining a function to automate the derivation of the EOMs for a system for us will save a significant amount of time and effort.

**Code:**
```julia
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

```