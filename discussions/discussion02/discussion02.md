Christian DiPietrantonio
ME5180
Discussion 02
02/04/2026


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Prompt: 
[Variational Calculus and Lagrange Equations](https://cooperrc.github.io/dynamics/notes/04_variational-methods/)

note: AI helped summarize the video transcript, feel free to submit PRs to fix typos/fixes

Variational calculus has solved a number of problems over time. One of the first questions was how to find functions to minimize the
brachistrochrone problem.

Have you heard this before? Have you seen brachistochrone solutions? What Differential equation defines the problem?

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Response:

Like many others, I have heard of the brachistrochrone problem from the Vsauce video. However, it had been a while since I had watched it, and revisiting the video after the lecture definitely gave me a greater appreciation for the problem than the first time I watched. The brachistochrone problem starts with the time functional; applying the Euler-Lagrange equation to this functional produces a second-order non-linear ordinary differential equation, the general solution to which is known to be a family of [cycloids](https://en.wikipedia.org/wiki/Cycloid). The particular solution (depending on your boundary conditions/endpoints) is the brachistochrone curve we all know and love. If we continued the example we started in lecture, we would find the following defining second-order non-linear ordinary differential equation:

$$
f'' = \frac{1 + (f')^2}{2(h-f)}
$$

Again, this ODE is known to have a general solution of a family of cycloids that can be written parametrically as:

$$
x(t) = r(t - \sin(t)) + C_x
$$

$$
y(t) = r(1 - \cos(t)) + C_y
$$

However, when we substitute our boundary conditions, we are left with a transcendental equation. Nevertheless, we can write a quick script in Julia to numerically solve for the solution to our particular brachistochrone problem (h=1,L=1). When we do so, we can create the following plot of the brachistochrone curve for the example we started in class!

<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/brachistochrone_sol.png?raw=true" width="400">
</p>

Although I had not heard of variational calculus prior to this course, it somewhat reminds me of the process of generating linear model data to fit to a state variable model. This can be accomplished by perturbing different effectors and recording the changes in the measurable/synthesized outputs. Such practices enable real-time predictive control!


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Submitted: TBD

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////