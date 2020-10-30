
%% Example 9.1 in recipes

% The continuation problem structure encoded below corresponds to a family
% of 151*(2N+1)+2+8N zero functions (120*(2N+1) collocation conditions,
% 27*(2N+1) continuity conditions, 2N+1 boundary conditions on the interval
% lengths, 3*(2N+1) Fourier interpolation conditions, two phase conditions,
% and 8N gluing conditions) in terms of 155*(2N+1) continuation variables
% (150*(2N+1) basepoint values, 2N+1 interval lengths, and 4*(2N+1) problem
% parameters), a family of four monitor functions, and the corresponding
% inactive continuation parameters 'om', 'ro', 'eps', 'T_ret'. Its
% dimensional deficit is -2. It follows that two continuation parameters
% must be released in order to obtain a unique solution to a closed
% continuation problem. Given 'om', and for 'eps'=0, a unique family of
% trajectory segments is obtained by solving also for 'ro', and 'T_ret'.
% Additional variations in 'eps' result in a one-dimensional branch of
% approximate quasiperiodic invariant tori. Alternatively, variations in
% 'ro' describe a one-dimensional branch of relative periodic orbits.

p0     = [3.5; 0.35; 0];
T_po   = 5.3; % Approximate period
N      = 50;  % 2N+1 = Number of orbit segments
tout   = linspace(0, T_po, 2*N+2);
[t x0] = ode45(@(t,x) lang_red(x,p0), tout, [0.3; 0.4]); % Approximate periodic orbit of reduced system

T_ret = 2*pi/p0(1); % return time = 2*pi/om
tt    = linspace(0,1,20*(2*N+1))';
t1    = T_ret*tt;
stt   = sin(tt*2*pi);
ctt   = cos(tt*2*pi);
xinit = zeros(numel(tt),3,2*N+1);
for i=1:2*N+1 % For each point on orbit, flow for return time and reconstitute 3D trajectory
  [t xx]    = ode45(@(t,x) lang_red(x,p0), [0 T_ret], x0(i,:));
  xx        = interp1(t, xx, t1);
  x1        = [ctt.*xx(:,1) stt.*xx(:,1) xx(:,2)]; % x0 -> [cos(t)*x0(:,1) sin(t)*x0(:,1) x0(:,2)]
  xinit(:,:,i) = x1; 
%   coll_args = [coll_args {@lang @lang_DFDX @lang_DFDP t1 x1 [p0; T_ret]}];
end
varrho = T_ret/T_po;

% construct continuation problem
prob = coco_prob();
prob = coco_set(prob, 'tor', 'autonomous', true, 'nOmega', 0);
prob = coco_set(prob, 'coll', 'MXCL', false);
prob = coco_set(prob, 'cont', 'NAdapt', 0, 'h_max', 10, 'PtMX', 50);
torargs = {@lang @lang_DFDX @lang_DFDP t1 xinit {'om','rho','eps','om1','om2','varrho'} [p0' 2*pi/T_po p0(1) varrho]};
% we choose negative om1 above because the rotation direction is opposite.
% In other words, the value of om1 can be both positive and negative
prob = ode_isol2tor(prob, '', torargs{:});

fprintf('\n Run=''%s'': Continue family of quasiperiodic invariant tori.\n', ...
  'torus');

coco(prob, 'run_eps', [], 1, {'eps','rho','om1','om2','om','varrho'}, [-0.3 0.3]);


% prob = coco_prob();
% prob = msbvp_isol2segs(prob, '', coll_args{:}, ...
%   {'om' 'ro' 'eps' 'T_ret'}, @torus_bc, @torus_bc_DFDX, data);
% coco(prob, 'run0', [], 0, {'ro' 'T_ret'}); % compute initial torus
% prob = msbvp_sol2segs(coco_prob(), '', 'run0', 1);

% run continuation along quasiperiodic arc
% coco(prob, 'run_eps', [], 1, {'eps' 'ro' 'T_ret'}, [-0.3 0.3]);

% Use the following command to perform continuation of relative periodic
% orbits of symmetric system. 
%
% coco(prob, 'run_ro', [], 1, {'ro' 'om' 'T_ret'}, [0 1]);

% coco_use_recipes_toolbox % remove the coll_v1 and msbvp_v1 toolboxes from the search path
