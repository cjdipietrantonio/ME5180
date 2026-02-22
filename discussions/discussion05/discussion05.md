Christian DiPietrantonio
ME5180
Discussion 05
02/21/2026

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Prompt:
[Using generalized coordinates and Lagrange Equations ](https://cooperrc.github.io/dynamics/tutorials/08_generalized-coords/) for a system of pulleys and blocks.

In this video and notebook, we can go through the analysis of degrees of freedom and choosing generalized coordinates for the Lagrange equations.

One big lesson is that # of DOFs == # of eoms

You will have one equation of motion for every degree of freedom. Many times, like the video, they are coupled to each other.

For the system of pulleys, try changing the masses of blocks 1, 2, and 3. Is there a way to have block one stationary, but blocks 2 and 3 move?

What other ways do degrees of freedom affect dynamics?

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Response:

Assuming that pulley 2 is massless and everything starts at rest, we know that block 1 remains stationary if $\ddot{y}_1 = 0$. To figure out when this is possible, we can rewrite our system of equations to solve for an expression for $\ddot{y}_1$:

$$
\ddot{y}_1 = 0 = \frac{\left[m_1 \left(m_2 + m_3\right) - 4 m_2 m_3\right]g}{m_1 \left(m_2 + m_3\right) + 4 m_2 m_3}
$$

For physical masses $m_{1}, m_{2}, m_{3} > 0$, the denominator is positive. Also, we know that $g \neq 0$, which leaves us with:

$$
m_1 \left(m_2 + m_3\right) - 4 m_2 m_3 = 0
$$

Therefore, for block 1 to remain stationary, we must have:

$$
m_1 = \frac{4 m_2 m_3}{m_2 + m_3}
$$

Now, if we impose $\ddot{y}_1 = 0$ on our second Lagrange equation,

$$
(-m_2 + m_3) \ddot{y}_1 + (m_2 + m_3)\ddot{y}_2 = (m_2 - m_3) g
$$

we obtain the following expression for $\ddot{y}_2$:

$$
\ddot{y}_2 = \frac{(m_2 - m_3) g}{m_2 + m_3}
$$

Which tells us that if $m_2 \neq m_3$, then $\ddot{y}_2 \neq 0$, and blocks 2 and 3 move! However, if $m_2 = m_3$, then $\ddot{y}_2 = 0$, and the entire system remains static. For the first example, I made the following changes to the Pluto notebook:

```Julia
begin
    m2 = 0.2
    m3 = 0.8
    m1 = (4*m2*m3)/(m2+m3)

    pulley_accel(m1, m2, m3)
end
```

```Julia
begin
	y1, p2, y2, y3 = calc_motion(m1, m2, m3)
	@gif for i in 1:length(y1)
		block_positions = Dict(
		    :block1 => (1.0, y1[i]),
		    :block2 => (1.8, y2[i]),
		    :block3 => (2.2, y3[i]),
		)
		
		pulley_positions = Dict(
		    :circle1 => (1.5, 2.0),  # big pulley
		    :circle2 => (2.0, p2[i]),  # small pulley
		)
		
		diagram_plot = plot_pulley_diagram(block_positions, pulley_positions)
		ylims!(-2, 3)
		diagram_plot
	end
end
```
From which we can confirm that blocks 2 and 3 move in opposite directions while block 1 remains stationary!
<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/discussions/discussion05/m2_lessthan_m3.gif?raw=true"
    width="400">
</p>

For the second case $m_2 = m_3$:

<p align="center">
    <img src="https://github.com/cjdipietrantonio/ME5180/blob/main/discussions/discussion05/m2_equals_m3.gif?raw=true"
    width="400">
</p>

As expected, everything remains static. From this example, we can see that the dynamics of a system are significantly influenced by the degrees of freedom. Not only do they determine the number of equations of motion required to describe the system, but also how the constraints shape the system's motion and how forces are coupled between components.