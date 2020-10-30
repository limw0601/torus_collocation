%% Continuation of quasiperiodic invariant tori
%
% Two-dimensional quasiperiodic invariant tori are characterized by a
% parallel flow with irrational rotation number. In terms of a suitably
% defined torus function, the dynamics on the torus may be described by an
% invariant circle that is mapped to itself by the flow, such that the flow
% is equivalent to a rigid rotation on the circle.
%
% We obtain an approximate description of a quasiperiodic invariant torus
% in terms of a Fourier representation of the invariant circle and a finite
% collection of trajectory segments based at points on the invariant
% circle. The rigid rotation imposes an all-to-all coupled system of
% boundary conditions on the collection of trajectory segments.

% Panel (a) shows a quasiperiodic arc, representing a family of
% quasiperiodic invariant tori. Selected members of this family are shown
% in panels (b) to (f).

%% Encoding

% Construct the guess of initial solution

% pnames = [  om     c     a ]
p0       = [ 1.5111; 0.11; 0.1 ];

T_po = 2*pi; % Approximate period
N    = 10;  % 2N+1 = Number of orbit segments
tout = linspace(0, T_po, 2*N+2);

T_ret = 2*pi/p0(1); % return time = 2*pi/om
tt    = linspace(0,1,10*(2*N+1))';
t1    = T_ret*tt;
x0    = zeros(numel(tt),2,2*N+1);

for i=1:2*N+1 % For each point on orbit, flow for return time and reconstitute 3D trajectory
  x1       = [2*cos(tout(i)) 2*sin(tout(i))];
  [~, x1] = ode45(@(t,x) vdp(t,x,p0), 10*t1, x1); % Transient simulation
  [~, x1] = ode45(@(t,x) vdp(t,x,p0), t1, x1(end,:));
  x0(:,:,i) = x1;
end

varrho = T_ret/T_po;

% construct continuation problem
prob = coco_prob();
prob = coco_set(prob, 'coll', 'NTST', 40);
prob = coco_set(prob, 'cont', 'NAdapt', 0, 'h_max', 2, 'PtMX', 200);
torargs = {@vdp @vdp_DFDX @vdp_DFDP @vdp_DFDT t1 x0 {'Om2','c','a','om1','om2','varrho'} [p0' -2*pi/T_po p0(1) -varrho]};
% we choose negative om1 above because the rotation direction is opposite.
% In other words, the value of om1 can be both positive and negative
prob = ode_isol2tor(prob, '', torargs{:});

fprintf('\n Run=''%s'': Continue family of quasiperiodic invariant tori.\n', ...
  'torus');

coco(prob, 'vdP_torus', [], 1, {'a','Om2','om2','om1', 'varrho','c'}, {[0.1 2] [1 2]});

%% Graphical representation of stored solutions

% Plot data: panel (a)
figure;
coco_plot_bd('vdP_torus', 'a', 'om2')
grid on

% Plot data: panels (b)-(f)
labs = [1 4 6 8 11];

for i=1:5
  figure(i+1); clf; hold on; grid on
  
  [sol, data] = bvp_read_solution('tor', 'vdP_torus', labs(i));
  N  = data.nsegs;
  M  = size(sol{1}.xbp,1);
  x0 = zeros(N+1,2);
  x1 = zeros(N+1,2);
  XX = zeros(M,N+1);
  YY = XX;
  ZZ = XX;
  for j=1:N+1
    n       = mod(j-1,N)+1;
    XX(:,j) = sol{n}.xbp(1:M,1);
    ZZ(:,j) = sol{n}.xbp(1:M,2);
    YY(:,j) = sol{n}.tbp(1:M);
    x0(j,:) = sol{n}.xbp(1,:);
    x1(j,:) = sol{n}.xbp(M,:);
  end
  surf(XX, YY, ZZ, 'FaceColor', 0.9*[1 1 1], 'FaceAlpha', 0.7, ...
    'MeshStyle', 'column', 'LineStyle', '-', 'EdgeColor', 0.6*[1 1 1], ...
    'LineWidth', 0.5);
  plot3(x0(:,1), zeros(N+1,1), x0(:,2), 'LineStyle', '-', 'LineWidth', 2, ...
    'Color', 'black', 'Marker', '.', 'MarkerSize', 12);
  plot3(x1(:,1), sol{n}.T*ones(N+1,1), x1(:,2), 'LineStyle', '-', 'LineWidth', 2, ...
    'Color', 'blue', 'Marker', '.', 'MarkerSize', 12);
  
  hold off; view([50 15])
  
end
