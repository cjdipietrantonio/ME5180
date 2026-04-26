Christian DiPietrantonio
ME5180
Discussion 12
04/26/2026

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Prompt:

[acceleration of piston kinematics](https://cooperrc.github.io/dynamics/tutorials/15_piston-full/)

[Lagrange formulation of MBD system](https://cooperrc.github.io/dynamics/tutorials/16_mbd-lagrange/)

[Augmented MBD method](https://cooperrc.github.io/dynamics/tutorials/17_augmented-MBD/)

In this module and these videos, we build up to the full equations and variables needed for Multibody Dynamics (MBD) simulations. These are the equations that physics simulators solve for 2d and 3d dynamic motion. 

What would these equations look like for a pendulum simulator? How many generalized coordinates? Constraints? How do you solve the Differential algebraic Equations (DAE)?

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Response:

For a simple pendulum (single-bar linkage), as shown in the final video, the MBD approach gives us three generalized coordinates that represent the position and orientation of the bar's center of mass. The pin joint at the pivot constrains the bar's endpoint, resulting in two constraint equations and one degree of freedom (which makes sense as the bar can only swing). As shown in the second and third videos above, the augmented technique stacks Newton's second law with the acceleration level constraints into one system:

$$
\begin{bmatrix}
M & C_{\vec{q}}^T \\
C_{\vec{q}} & 0
\end{bmatrix}
\begin{bmatrix}
\ddot{\vec{q}} \\
\vec{\lambda}
\end{bmatrix}
=
\begin{bmatrix}
\vec{Q}_e \\
\vec{Q}_d
\end{bmatrix}
$$

where (in the case of the simple pendulum) $M$ is a $3 \times 3$ mass matrix, $C_{\vec{q}}$ is a $2 \times 3$ Jacobian, $\vec{Q}_e$ contains the external forces (gravity), and $\vec{Q}_d$ collects the known terms from differentiating the constraints twice. The unknowns are the accelerations $\ddot{\vec{q}}$, and the two Lagrange multipliers ($\lambda_{1}$ and $\lambda_{2}$). Therefore, at each time step, a $5 \times 5$ linear system must be solved. 

To solve this DAE, the simplest approach is Euler integration:

$$
\vec{y}(t + \Delta t) = \vec{y}(t) + \Delta t \, \dot{\vec{y}}(t)
$$

The linear system mentioned above is solved at each step for $\ddot{\vec{q}}$, integrated forward to obtain positions and velocities for the next step, then the process is repeated. One thing Professor Cooper mentioned is that integrating at the acceleration level can lead to instabilities, which can be corrected using the Baumgarte stabilization technique.
