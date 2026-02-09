Christian DiPietrantonio
ME5180
Discussion 02
02/09/2026


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Prompt:
[Numerical integration and principle of least action](https://cooperrc.github.io/dynamics/tutorials/06_least-action/)

I ended up recording x2 sessions for this topic because I ran into numerical instabilities for the [brachistochrone](https://cooperrc.github.io/dynamics/tutorials/03_brachistochrone/) differential equations. Sometimes its a nice reminder that no matter how long you've been using these tools, you can hit an error that you didn't expect.

Try your own functions for the harmonic oscillator solutions to see what changes in total action are here,
[06_least-action.jl](https://github.com/cooperrc/dynamics/blob/main/tutorials/06_least-action.jl) notebook

paste the link into your Pluto notebook and paste the describe the result here.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Response:

Instead of trying a handful of functions to test the principle of least action, I decided to automate the approach to this problem using Julia. I started with the analytical solutions from the lecture video:

$$
x_{an} = A\cos{\omega t} + B\sin(\omega t)
$$

$$
v_{an} = \omega \left(-A\sin(\omega t) + B\cos(\omega t)\right)
$$

I then created a general form for a trial path that would add a scaled adder onto the analytical solution while matching its boundary condtions:

$$
x_{trial} = x_{an} + a\sin\left(\frac{\pi t}{T_{total}}\right)
$$

This works because at initial time, $t = 0$, and final time, $t = T_{total}$, the adder is equal to the analytical solution. 

