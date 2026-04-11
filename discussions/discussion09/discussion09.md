Christian DiPietrantonio
ME5180
Discussion 09
04/11/2026

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Prompt:

[Solving Kinematic Constraints](https://cooperrc.github.io/dynamics/tutorials/12_solve-kinematics/)

In this video, I revisit building the kinematic equations for the opening door. This type of 'Multibody Dynamic' simulation is a 0-DOF system i.e. the motion is completely prescribed and the forces exist to enforce the motion, [inverse dynamics](https://en.wikipedia.org/wiki/Inverse_dynamics). Project_01 was a classic dynamic problem where motion depends upon changing applied forces. 

How would you change the constraints on opening the door? Can you create a constraint equation for using the door knob?

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Response:

In the lecture, the door's motion is prescribed by constraining the center of mass directly with $R_{1y} = 2t$. To change the constraints so that the motion is driven by the doorknob instead, we could replace that driving constraint with one applied to the knob/handle point. The knob location in global coordinates is $R_{Hx} = R_{1x} + x_H \cos{\theta_1} - y_H \sin{\theta_1}$ (for the x-component) and $R_{Hy} = R_{1y} + x_H \sin{\theta_1} + y_H \cos{\theta_1}$ (for the y-component), where $(x_H, y_H)$ are the handle's offsets from the center of mass of the door in its own reference frame. If we want to drive the door's motion from the knob, we could write a constraint like $R_{Hy} = v \cdot t$, which expands to $R_{1y} + x_H \sin{\theta_1} + y_H \cos{\theta_1} = v \cdot t$. When combined with the two hinge constraints, we still have a fully constrained (0-DOF) system, but now the kinematics are driven from the knob rather than the center of mass of the door. It's worth noting that as the door approaches $90^{\circ}$, the knob/door's velocity becomes primarily horizontal, and a purely y-driving constraint wouldn't physically make sense (as shown in the video). 