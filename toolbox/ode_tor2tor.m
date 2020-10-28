function prob = ode_tor2tor(prob, oid, varargin)
%ODE_tor2tor   Append 'tor' instance constructed from saved data.
%
% Support restarting continuation from a previously obtained solution,
% stored to disk.
%
% PROB     = ODE_TOR2TOR(PROB, OID, VARARGIN)
% VARARGIN = { RUN [SOID] LAB }
%
% PROB - Continuation problem structure.
% OID  - Target object instance identifier (string).
% RUN  - Run identifier (string).
% SOID - Source object instance identifier (string).
% LAB  - Solution label (integer).

tbid = coco_get_id(oid, 'tor'); % Create toolbox instance identifier
str  = coco_stream(varargin{:}); % Convert varargin to stream of tokens for argument parsing
run  = str.get;
if ischar(str.peek)
  soid = str.get;
else
  soid = oid;
end
lab = str.get;

[sol,data] = tor_read_solution(soid, run, lab);  % Extract solution and toolbox data from disk
data       = tor_get_settings(prob, tbid, data); % Get toolbox settings
data       = tor_init_data(data, sol.x0, sol.p);  % Build toolbox data
sol        = tor_init_sol(sol.T0, sol.T, sol.x0, sol.x1, sol.p, sol.t0);  % Build initial solution guess
prob       = ode_construct_tor(prob, tbid, data, sol); % Append continuation problem

end
