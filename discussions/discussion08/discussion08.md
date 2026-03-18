Christian DiPietrantonio
ME5180
Discussion 08
03/18/2026

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Prompt:

[Creating Kinematic Constraints](https://cooperrc.github.io/dynamics/tutorials/11_constraints/)

In this notebook + video, I go through the process of creating formal constraint equations on the motion of a door (from the top-down perspective i.e. watching the swinging motion in plane). This process is the beginning of Module_02's work to create Multibody Dynamic (MBD) Differential Algebraic Equations (DAE).

Here, we make the Constraint equations for a hinge. What would the Constraint equations be for a sliding (or prismatic) constraint?

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Response:

In order to determine the constraint equations for the same door with a sliding (or prismatic constraint), we can begin by trying to understand what the sliding joint does physically. In doing so, we can determine that a sliding joint would allow translation of the door in one direction only (for this example, lets say along the x-axis). We can also determine that the sliding joint constrains translation in the y-direction, and prevents rotation. Now, because in this example our constraints do not depend on a point on the door other than its Center of Mass, we do not have to use a rotation matrix to convert between coordinate systems. However, we still have the same generalized coordinates as the original problem, which are required to define the position of the Center of Mass of the door in 2D:

$$
\vec{q} =
\begin{bmatrix}
x_1 \\
y_1 \\
\theta_1
\end{bmatrix}
$$
Since the door cannot translate in the y direction, and it cannot rotate, we can write its position constraints in matrix form as:

$$
\vec{C} \left( \vec{q} \right) =
\begin{bmatrix}
y_1 \\
\theta_1 \\
\end{bmatrix}
=
\begin{bmatrix}
0 \\
0 \\
\end{bmatrix}
$$

Therefore, only $x_1$ is left free, and the door is free to translate in the x-direction. We must now determine the velocity constraints. Given that:

$$
\frac{d}{dt} \left( \vec{C}\left( \vec{q} \right) \right) = C_q \dot{\vec{q}} = -\vec{C}_t
$$

where

$$
C_q = 
\begin{bmatrix}
\frac{\partial y_1}{\partial x_1} & \frac{\partial y_1}{\partial y_1} & \frac{\partial y_1}{\partial \theta_1} \\
\frac{\partial \theta_1}{\partial x_1} & \frac{\partial \theta_1}{\partial y_1} & \frac{\partial \theta_1}{\partial \theta_1}
\end{bmatrix}
=
\begin{bmatrix}
0 & 1 & 0 \\
0 & 0 & 1
\end{bmatrix}
$$

and 

$$
\vec{C}_t = \frac{\partial \vec{C}}{\partial t} =
\begin{bmatrix}
0 \\
0
\end{bmatrix}
$$

Therefore, our velocity constraint equations can be expressed in matrix form as:

$$
\begin{bmatrix}
0 & 1 & 0 \\
0 & 0 & 1
\end{bmatrix}
\begin{bmatrix}
\dot{x_1} \\
\dot{y_1} \\
\dot{\theta_1}
\end{bmatrix}
=
\begin{bmatrix}
0 \\
0
\end{bmatrix}
$$

From this, we can see that the doors angular velocity, and y-velocity are also constrained to zero, which makes sense given that it cannot move with regards to either.