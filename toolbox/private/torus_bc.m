function fbc = torus_bc(data, T0, T, x0, x1, p)
%TORUS_BC   Torus boundary conditions.
%
% Trajectory end points lie on a curve on the invariant torus. The return
% map corresponds to identical times-of-flight and describes a rigid
% rotation.

Om = p(data.Omidx);
om = p(end-1);
varrho = p(end);
Th  = (1:data.N)*2*pi*varrho;
SIN = [ zeros(size(Th)) ; sin(Th) ];
R   = diag([1 kron(cos(Th), [1 1])]);
R   = R  + diag(SIN(:), +1)- diag(SIN(:), -1);
RF  = kron(R*data.Fs, eye(data.dim));

fbc = [T0; T-2*pi/Om; data.F*x1-RF*x0; om-varrho*Om; x0(2)];

% nt = numel(T);
% nx = numel(x0);
% np = numel(p);
% 
% J1 = zeros(1,2*nt+2*nx+np);
% J1(1,2*nt+2) = 1;
% 
% Jbc = [
%   eye(nt), zeros(nt,nt+2*nx+np);
%   zeros(nt), eye(nt), zeros(nt,2*nx), 2*pi/p(1)^2*ones(nt,1), zeros(nt,np-1);
%   zeros(nx,2*nt), -data.RF, data.F, zeros(nx,np);
%   J1];
end
