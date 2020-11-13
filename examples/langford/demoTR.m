p0 = [3.5; 1.5; 0]; % [om ro eps]
T  = 2*pi/p0(1);
[~,x0] = ode45(@(t,x) lang(x,p0), 0:100*T, [0.3; 0.4; 0]); % Approximate periodic orbit of reduced system
[t0,x0] = ode45(@(t,x) lang(x,p0), linspace(0,T,100), x0(end,:));
figure;
plot(t0,x0);

%% continuation of periodic orbit
prob = coco_prob();
prob = ode_isol2po(prob, '', @lang, @lang_DFDX, @lang_DFDP, ...
  t0, x0, {'om','rho','eps'}, p0);

fprintf('\n Run=''%s'': Continue family of periodic orbits.\n', ...
  'po');

coco(prob, 'po', [], 1, 'rho', [0.2 2]);

%% continuation of torus from TR point
bd    = coco_bd_read('po');
TRlab = coco_bd_labs(bd, 'TR');
prob = coco_prob();
prob = coco_set(prob, 'tor', 'autonomous', true, 'nOmega', 0);
prob = coco_set(prob, 'cont', 'NAdapt', 5, 'h_min', 1e-3, 'PtMX', 100, 'h_max', 10);
prob = ode_TR2tor(prob, '', 'po', TRlab, 10);
fprintf(...
  '\n Run=''%s'': Continue torus from point %d in run ''%s''.\n', ...
  'tr1', TRlab, 'po');
coco(prob, 'tr1', [], 1, {'eps','rho','om1','om2','varrho'});
plot_torus('','tr1', 5, 1);
