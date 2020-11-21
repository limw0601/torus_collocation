%% Continuation of quasiperiodic invariant tori
% 
%% Encoding
% Construct the guess of initial solution
% pnames = [  om  a ]
p0 = [ 2; 0.4 ];
T  = 2*pi/p0(1);
[~,x0]  = ode45(@(t,x) net(t,x,p0), 0:1000*T, zeros(8,1)); % Approximate periodic orbit of reduced system
[t0,x0] = ode45(@(t,x) net(t,x,p0), linspace(0,T,200), x0(end,:));

%% continuation of periodic orbit
prob = coco_prob();
prob = coco_set(prob, 'ode', 'autonomous', false);
prob = coco_set(prob, 'cont', 'NAdapt', 5, 'h_max', 5);
prob = coco_set(prob, 'coll', 'NTST', 20);
prob = ode_isol2po(prob, '', @net, ... % @lang_DFDX, @lang_DFDP
  t0, x0, {'Om2','f'}, p0);
[data, uidx] = coco_get_func_data(prob, 'po.orb.coll', 'data', 'uidx');
maps = data.coll_seg.maps;
prob = coco_add_func(prob, 'OmegaT', @OmegaT, @OmegaT_du, [], 'zero',...
    'uidx', [uidx(maps.T_idx), uidx(maps.p_idx(1))]);

fprintf('\n Run=''%s'': Continue family of periodic orbits.\n', ...
  'po');

coco(prob, 'po', [], 1, {'Om2','po.period'}, [1.9 2.1]);

figure; coco_plot_bd('po')

%% continuation of torus bifurcation points
bd     = coco_bd_read('po');
TRlabs = coco_bd_labs(bd, 'TR');
TRlab  = max(TRlabs);
prob = coco_prob();
prob = coco_set(prob, 'ode', 'autonomous', false);
prob = coco_set(prob, 'cont', 'NAdapt', 5, 'h_max', 5);
prob = ode_po2TR(prob, '', 'po', TRlab);
[data, uidx] = coco_get_func_data(prob, 'po.orb.coll', 'data', 'uidx');
maps = data.coll_seg.maps;
prob = coco_add_func(prob, 'OmegaT', @OmegaT, @OmegaT_du, [], 'zero',...
    'uidx', [uidx(maps.T_idx), uidx(maps.p_idx(1))]);

fprintf('\n Run=''%s'': Continue family of TR points.\n', ...
  'po_TR');

coco(prob, 'po_TR', [], 1, {'f','Om2','po.period','f'}, [0.4 6]);


%% continuation of torus from TR point
bd    = coco_bd_read('po_TR');
TRlab = coco_bd_labs(bd, 'EP');
TRlab = max(TRlab);
prob = coco_prob();
prob = coco_set(prob, 'cont', 'NAdapt', 5, 'PtMX', 50, 'h_max', 5,...
    'h_min', 1e-4);
prob = ode_TR2tor(prob, '', 'po_TR', TRlab, 'neg', 1e-8);
fprintf(...
  '\n Run=''%s'': Continue torus from point %d in run ''%s''.\n', ...
  'tr1', TRlab, 'po_TR');
coco(prob, 'tr1', [], 1, {'varrho','Om2','om2','om1','f'});

for lab = 4:8
    plot_torus('','tr1',lab,[1 5]); pause(1);
end


%% continuation of torus with fixed varrho
lab  = 7;
prob = coco_prob();
prob = coco_set(prob, 'cont', 'NAdapt', 5, 'PtMX', 100, 'h_max', 50);
prob = ode_tor2tor(prob, '', 'tr1', lab);
fprintf(...
  '\n Run=''%s'': Continue torus from point %d in run ''%s''.\n', ...
  'tr2', lab, 'tr1');
coco(prob, 'tr2', [], 1, {'f','Om2','om2','om1','varrho'},[0.4 6]);

%% continuation of torus with varied varrho and f=0.4
bd  = coco_bd_read('tr2');
lab = coco_bd_labs(bd, 'EP');
lab = max(lab);
prob = coco_prob();
prob = coco_set(prob, 'cont', 'NAdapt', 5, 'PtMX', 100, 'h_max', 50);
prob = ode_tor2tor(prob, '', 'tr2', lab);
fprintf(...
  '\n Run=''%s'': Continue torus from point %d in run ''%s''.\n', ...
  'tr3', lab, 'tr2');
coco(prob, 'tr3', [], 1, {'Om2','om2','om1','varrho','f'},[2.0 2.1233]);

for lab = 1:12
    plot_torus('','tr3',lab,[1 5]); pause(1);
end
