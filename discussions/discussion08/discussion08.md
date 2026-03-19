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

In order to determine the constraint equations for the same door with a sliding (or prismatic) constraint, we can begin by trying to understand what the sliding joint does physically. A sliding joint allows translation of the door in one direction only (let's say along the x-axis). Therefore, the sliding joint constrains translation in the y-direction, and prevents rotation. In this example, we can assume that the sliding constraint is applied at the Center of Mass (COM) of the door (if it wasn't, we would have to include an offset term and a rotation matrix (which would reduce to the identity matrix due to the constraint on $\theta_1$) in our constraint equations). We still have the same generalized coordinates as the original problem, which are required to define the position of the COM of the door in 2D:

$$
\vec{q} =
\begin{bmatrix}
x_1 \\
y_1 \\
\theta_1
\end{bmatrix}
$$

Since the door cannot translate in the y direction, and it cannot rotate, we can write its position constraints as:

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

Because our constraints do not depend on a point on the door other than its COM, we do not have to use a rotation matrix to convert between coordinate systems. Therefore, we can see that only $x_1$ is left free, and the door can translate in the x-direction. We must now determine the velocity constraints. Given that:

$$
\frac{d}{dt} \left( \vec{C}\left( \vec{q}, t \right) \right) = C_q \dot{\vec{q}} = -\vec{C}_t
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

Our velocity constraint equations can be expressed in matrix form as:

$$
\begin{bmatrix}
0 & 1 & 0 \\
0 & 0 & 1
\end{bmatrix}
\begin{bmatrix}
\dot{x}_1 \\
\dot{y}_1 \\
\dot{\theta}_1
\end{bmatrix}
=
\begin{bmatrix}
0 \\
0
\end{bmatrix}
$$

From this, we can see that the door's angular velocity $( \dot{\theta}_1 )$ and y-velocity $( \dot{y}_1 )$ are also constrained to zero, which makes sense given the position constraints shown above.