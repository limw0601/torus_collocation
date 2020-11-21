# Torus toolbox for dynamical systems

This repo presents a torus toolbox for *autonomous* systems and *non-autonomous* systems subject to *harmonic* external forcing. It calculates a family of tori based on parameter continuation. This toolbox includes

 * ode_TR2tor: continuation of tori arising from a Neimark-Sacker or torus (TR) bifurcation periodic orbit;
 * ode_isol2tor: continuation of tori from an initial solution guess;
 * ode_tor2tor: continuation of tori from a saved torus solution;
 * ode_BP2tor: continuation of tori along a secondary branch passing through a branch point.


Finding torus is formulated as a boundary-value problem (BVP) governed by a partial-differential equation (PDE). With the method of characteristics, the PDE is reduced to an ordinary differential equation (ODE) and the BVP problem is reduced to a multi-segments BVP, which is governed by a set of ODEs with all-to-all boundary coupling condition.

This toolbox relies on continuation package COCO, a MATLAB-based toolbox for numerical continuation. Please refer https://sourceforge.net/projects/cocotools/ for the info and installation of COCO. The multi-segments BVP is encoded with the *bvp*-toolbox in COCO.
