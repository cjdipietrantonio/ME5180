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
In order to find the true optimum combination of stiffness and damping (if the goal is to stop the pendulum from moving), I wrote a julia script that sweeps over different combinations of the two parameters. For each simulation, I stored the sum of $\theta^2$ over the entire 
time domain to serve as a measure of how fast the pendulum stopped moving. Doing so accounts for large oscilations and slow decay, so a pendulum that stops quickly has a lower sum. For this analysis, other parameters (mass, length, gravity, and initial angle) were fixed, however a similar approach could be used to find the optimum combination of more/other parameters.

The sweep found an optimum aroung b = [TBD] kg/s and k = [TBD] n/m. As shown in the heatmap, per.

Large b decouples the pendulum and cart responsible for energy transfer. Stiff damper holds card in place. Pendulum just swings as it would normally. 

ADD PLOTS 