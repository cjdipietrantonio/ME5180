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

The code below defines a function that takes the following inputs:
- Expressions for the kinetic and potential energy ($$T$ and $V$)
- A vector of non-conservative forces $(F_q)$
- Vectors for generalized coordinates ($\vec{q}$) and their time derrvatives $(\dot{\vec{q}})$
- A symbolic variable for time $(t)$

The function uses the Euler-Lagrange equation to to build a symbolic equation for each generalized coordinate. It then converts the 2nd-order equations into a 1st-order system, which is returned as an `ODEsystem` struct, `sys`. 

In the main driver, parameters for a physical system (the compound pendulum shown in the lecture) are defined and passed into the `build_lagrangian_system()` function. The resulting `sys` struct is then passed to `ODEProblem()` function along with the initial conditions and time span of the system. The result of this (`prob` struct) is then passed to the `solve()` function, which returns a `sol` struct. From this, the state-vector data can be accessed for plotting/further analysis. For this system, the following plot was created:

<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/discussions/discussion05/m2_lessthan_m3.gif?raw=true"
    width="400">
</p>

Which shows....

Overall, defining a function to automate the derivation of the EOMs for a system for us will save a significant ammount of time and effort.

Code:
