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

Instead of trying a handful of functions to test the principle of least action, I decided to automate the approach to this problem using Julia. I started with the analytical solutions in the lecture:

$$
x_{an} = A\cos{\omega t} + B\sin(\omega t)
$$

$$
v_{an} = \omega \left(-A\sin(\omega t) + B\cos(\omega t)\right)
$$

I then created a general form for a trial path that adds a scaled perturbation onto the analytical solution while still matching its boundary conditions:

$$
x_{trial} = x_{an} + a\sin\left(\frac{\pi t}{T_{total}}\right)
$$

This works because the sine term is zero at the initial time, $t = 0$, and the final time, $t = T_{total}$, so every trial path will equal the analytical solution at those endpoints. Next, I created 101 equally spaced values of $a$ between -1 and 1, which produces a family of different trial paths. Graphically, this looks like:

<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/discussions/discussion03/trial_paths.png?raw=true"
    width="400">
</p>

For each trial path, I then calculated the velocity, which allowed me to find the lagrangian. Finally, I numerically integrated the lagrangian, as shown in the lecture video, to find the action for each trial path. Plotting the action for each trial path versus its respective scalar, $a$, gave the following plot: 

<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/discussions/discussion03/action_plot.png?raw=true"
    width="400">
</p>

 According to the principle of least action, we would expect that the action is minimized for the analytical solution $\left(a=0\right)$. However, my plot shows that although the action of the analytical solution is closest to zero, it seems to be a local maximum. I originally thought I had made a mistake, but upon further research, I learned that the particular solution/physical path occurs where the action is stationary (i.e., stops changing to the first order when you perturb the inputs), which could be a local minimum, maximum, or inflection point. This is also consistent with the negative action we were seeing in the lecture video. I haven't yet had a chance to investigate what affects the concavity of the action, so if anyone has any insights on this, let me know!

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Submitted: 02/09/2025

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////