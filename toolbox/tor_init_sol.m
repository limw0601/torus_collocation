function sol = tor_init_sol(args,t0)
%TOR_INIT_SOL   Build initial solution guess.
%
% Construct initial solution guess for 'tor' toolbox.
%
% SOL = TOR_INIT_SOL(DATA, T0, X0, P0)
%
% T0   - Array of temporal mesh points.
% X0   - Array of state vectors at mesh points.
% P0   - Initial solution guess for problem parameters.

sol.t = args.t0;
sol.x = args.x0;
sol.p = args.p0;
sol.t0 = t0;

end
