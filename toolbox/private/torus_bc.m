function fbc = torus_bc(data, T0, T, x0, x1, p)
%TORUS_BC   Torus boundary conditions.
%
% Trajectory end points lie on a curve on the invariant torus. The return
% map corresponds to identical times-of-flight and describes a rigid
% rotation.

om1    = p(end-2);
om2    = p(end-1);
varrho = p(end);
Th  = (1:data.N)*2*pi*varrho;
SIN = [ zeros(size(Th)) ; sin(Th) ];
R   = diag([1 kron(cos(Th), [1 1])]);
R   = R  + diag(SIN(:), +1)- diag(SIN(:), -1);
RF  = kron(R*data.Fs, eye(data.dim));

fbc1 = [T0; T-2*pi/om2; data.F*x1-RF*x0; om1-varrho*om2];
switch data.nOmega
    case 0
        phase1 = data.f00'*(x0(1:data.dim)-data.x00);
        phase2 = data.f0'*(x0(1:data.dim)-data.x0);
        fbc2   = [phase1; phase2];
        
    case 1
        Om2 = p(data.Om2idx);
        par_coup = Om2-om2;
%         phase    = x0(2); % a phase condition which is not general
        % Poincare condition: <v^ast_\phi, v(0,0)-v^\ast>=0 
        % Here v(0,0) is the evaluation of the first segment at t=0. v^\ast
        % is the same evaluation at the solution of previous continuation
        % step.
        phase = data.f00'*(x0(1:data.dim)-data.x00);
        fbc2  = [par_coup; phase];
        
    case 2
        Om1 = p(data.Om1idx);
        Om2 = p(data.Om2idx);
        par_coup = [Om1-om1; Om2-om2];
        fbc2     = par_coup;        
        
    otherwise
        error('The number of external frequency components: {1,2,3}');
        
end

fbc = [fbc1; fbc2];



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
