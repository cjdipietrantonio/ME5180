Christian DiPietrantonio
ME5180
Discussion 07
03/10/2026

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Prompt:

[Solving the damped pendulum equations of motion](https://cooperrc.github.io/dynamics/tutorials/10_damped-pendulum/)

In this notebook and 2 videos, I go through the troubleshooting to get a set of coupled differential equations into a solveable form and then visualize the results to see the predicted motion. Two things surprised me in this analysis:

1. You can damp the motion of a pendulum by allowing the base to move

2. There is an optimum damping coefficient that allows motion to slow

What do you find as the optimum combination of stiffness and damping if the goal is to stop the pendulum from moving? What other parameters are you considering in the analysis?

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Response:

In order to find the true optimum combination of stiffness and damping (if the goal is to stop the pendulum from moving), I wrote a julia script that sweeps over different combinations of the two parameters. For each simulation, I stored the last time $\left|{\theta}\right|$ was greater than 0.01 radians (essentially the settling time in seconds). Other parameters (mass, length, gravity, and initial angle) were fixed to match the notebook, however a similar approach could be used to optimize over more parameters.

The sweep found an optimum of $b = 0.27$ kg/s and $k = 0.28$ N/m, which resulted in the pendulum coming to rest in roughly 0.98 seconds. The results of the sweep are visualized in the heat map and time trace below:

<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/discussions/discussion07/optimum.png?raw=true"
    width="500">
</p>
<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/discussions/discussion07/time_history.png?raw=true"
    width="500">
</p>

The heat map provides a nice visual of the resulting times of using different combinations of $b$ and $k$. The time trace displays the $\theta$ vs time for the optimum we found previously, the initial notebook default, and a low damping case. The results shown here confirm that the combination of $b$ and $k$ we found is in fact the optimal solution to stop the pendulum from moving (to a given tolerance).

The heat map also confirms the observation about high damping. We can see that as the damping coefficient increases, the time for the pendulum to come to rest also increases. This makes sense because a large damping coefficient locks the cart in place, decoupling it from the pendulum. Without cart movement, no energy can be transferred from the pendulum into the spring-damper system, and the pendulum swings freely (without damping, because we have not included any other damping forms in our model) as if its base were stationary.