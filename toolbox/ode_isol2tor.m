function prob = ode_isol2tor(prob, oid, varargin)
%ODE_ISOL2tor   Append 'tor' instance constructed from initial data.
%
% Parse input sequence to construct toolbox data and initial solution guess
% and use this to construct an instance of 'tor'.
%
% PROB     = ODE_ISOL2TOR(PROB, OID, @F @DFDX @DFDP T0 T X0 X1 PNAMES P0)
% VARARGIN = { @DFDT|[], @DFDXDX|[], @DFDXDP|[], @DFDPDP|[] }
%
% PROB   - Continuation problem structure.
% OID    - Object instance identifier (string).
% @F     - Function handle to vector field.
% @DFDX  - Optional function handle to Jacobian w.r.t. problem variables.
% @DFDP  - Optional function handle to Jacobian w.r.t. problem parameters.
% T0     - Initial time.
% T      - Time period.
% X0     - Initial state.
% X1     - Final state.
% PNAMES - Optional string label or cell array of string labels for
%          continuation parameters tracking problem parameters.
% P0     - Initial solution guess for problem parameters.

tbid = coco_get_id(oid, 'tor'); % Create toolbox instance identifier

grammar   = 'F [DFDX [DFDP [DFDT]]] T0 X0 [PNAMES] P0 [OPTS]';
args_spec = {
       'F',     '',     '@',      'fhan', [], 'read', {}
    'DFDX',     '',  '@|[]',   'dfdxhan', [], 'read', {}
    'DFDP',     '',  '@|[]',   'dfdphan', [], 'read', {}
    'DFDT',     '',  '@|[]',   'dfdthan', [], 'read', {}
      'T0',     '', '[num]',        't0', [], 'read', {}
      'X0',     '', '[num]',        'x0', [], 'read', {}
  'PNAMES', 'cell', '{str}',    'pnames', {}, 'read', {}
      'P0',     '', '[num]',        'p0', [], 'read', {}
  };
opts_spec = {
  '-coll-end',     '', '',  'end', {}
  '-end-coll',     '', '',  'end', {}
       '-var', 'vecs', [], 'read', {}
  };
[args, ~] = coco_parse(grammar, args_spec, opts_spec, varargin{:});

% tor_arg_check(tbid, args);    % Validate input
assert(numel(args.p0)==numel(args.pnames) || isempty(args.pnames), ...
  '%s: incompatible number of elements for ''p0'' and ''pnames''', ...
  tbid);
% data = tor_get_settings(prob, tbid, data);       % Get toolbox settings
data = tor_init_data(args);                      % Build toolbox data

N = data.N;
coll = cell(1,2*N+1);
t0 = args.t0;
p0 = args.p0;
for i=1:2*N+1
  x0 = args.x0(:,:,i);
  coll{i} = {data.fhan data.dfdxhan data.dfdphan data.dfdthan t0 x0 p0};
end


% Use the 'F+dF' option of the ode_isol2bvp constructor, since @torus_bc
% evaluates both the residual of the boundary conditions and the
% corresponding Jacobian.
% prob = coco_prob();
% prob = coco_set(prob, 'ode', 'autonomous', false);
% prob = coco_set(prob, 'coll', 'NTST', 20);
% prob = coco_set(prob, 'cont', 'NAdapt', 1, 'h_max', 10);
prob = ode_isol2bvp(prob, '', coll, args.pnames, @torus_bc, data);



% prob = ode_construct_tor(prob, tbid, data, sol); % Append continuation problem

end