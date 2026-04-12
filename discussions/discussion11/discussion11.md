Christian DiPietrantonio
ME5180
Discussion 11
04/12/2026

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Prompt:

[Kinematic solutions for a piston-crank system](https://cooperrc.github.io/dynamics/tutorials/14_piston-crank/)

In this notebook + video, we go through the analysis of a multibody dynamic simulation for piston-crank kinematics. We keep track of more variables (12 instead of 2-3), but we get a glimpse into how MBD systems and kinematic constraints can be handled in a more general sense of interacting rigid bodies. 

Can you recreate the graphs in [Shabana's prescribed_rotation_of_the_crankshaft](https://learning.oreilly.com/library/view/computational-dynamics-3rd/9780470686157/ch03.html#prescribed_rotation_of_the_crankshaft)? This is a great verification step that shows our solution process is repeatable. 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Response:

With the results from the code Professor Cooper wrote during the lecture video, we can recreate the graphs shown in Shabana's "Prescribed Rotation of the Crankshaft" example. Below are the results for the connecting rod and slider block. The position level plots show the connecting rod orientation and slider block displacement versus crank angle (as shown in Figures 3.37a and 3.37b of Shabana). The velocity level plots show the angular velocity of the connecting rod and the velocity of the slider block versus crank angle (as shown in Figures 3.38a and 3.38b of Shabana). We can observe that these plots generally match the shapes and values shown in Shabana's figures.

<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/discussions/discussion11/shabana_verification.png?raw=true" width="750">
</p>

The code from the lecture could also be updated to compute the accelerations for each body by taking the time derivative of the velocity constraint equation and solving the resulting linear system at each time step. Nevertheless, the plots above demonstrate the agreement between our simulation results and those shown in Chapter 3 of the text. In Chapter 3, other plots show the positions, velocities, and accelerations of the crankshaft/connecting rod versus time. These plots could also be recreated by following the same process used to make the plots above!
