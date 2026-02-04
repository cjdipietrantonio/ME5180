Christian DiPietrantonio
ME5180
Discussion 01
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

The solution to the bracristocrone problem is a second order non-linear ordinary differential equation, 
the general solution to which is known to be a family of [cycloids](https://en.wikipedia.org/wiki/Cycloid). 
The particular solution (depending on your boundary conditions/end points) is the 
brachistocrone curve we all know and love. If we continued the example we started in lecutre, we would find the following
second order non-linear ordinary differential equation:

$$
f'' = \frac{1 + (f')^2}{1-f}
$$

Again, this ODE is known to have a general solution of a family of cycloids that can be written parametrically as:

$$
x(t) = r(t - \sin(t)) + C_x
$$

$$
y(t) = r(1 - \cos(t)) + C_y
$$

However, when we subsitute our boundary conditions,
we are left with a trancendental equation. Nevertheless, we can write a quick script in Julia to numerically solve for the solution to our particular 
brachistocrone solution (h=1,L=1). When we do so, we can create the following plot of the brachistocrone curve for the example we started in class!
(FIND PARTICULAR SOLUTION FOR THE IN CLASS EXAMPLE and plot it!)

Although I have not heard of variational calculus prior to this course, it reminds me of the process of generating linear model data to fit to a state 
variable model by perturbing different effectors and recording the changes in the measurable/synthesized outputs. 
Such practices enable real-time predictive control!


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Submitted: TBD

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////