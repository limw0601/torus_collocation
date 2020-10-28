function data = tor_init_data(args)
%TOR_INIT_DATA   Initialize toolbox data for an instance of 'tor'.
%
% Populate remaining fields of the toolbox data structure used by 'tor'
% function objects.
%
% DATA = TOR_INIT_DATA(DATA, X0, P0)
%
% DATA - Toolbox data structure.
% X0   - Initial solution guess initial states.
% P0   - Initial solution guess for problem parameters.

[~,dim,nsegs] = size(args.x0);
assert(mod(nsegs,2)==1, 'the number of segments is not an odd number');
N = (nsegs-1)/2;

% Construct boundary conditions data, Fourier transform and rotation matrix
Th = 2*pi*(0:2*N)/(2*N+1);
Th = kron(1:N, Th');
F  = [ones(2*N+1,1) 2*reshape([cos(Th);sin(Th)], [2*N+1 2*N])]'/(2*N+1);

data = struct();
data.dim     = dim;
data.N       = N;
data.nsegs   = nsegs;
data.Fs      = F;
data.F       = kron(F, eye(dim));
data.fhan    = @(t,x,p) args.fhan(t,x,p(1:end-2,:)); % with om and varrho added as the last two parameters
if isempty(args.dfdxhan)
    data.dfdxhan = [];
else
    data.dfdxhan = @(t,x,p) args.dfdxhan(t,x,p(1:end-2,:));
end
if isempty(args.dfdphan)
    data.dfdphan = [];
else
    data.dfdphan = @(t,x,p) [args.dfdphan(t,x,p(1:end-2,:)) zeros(size(x,1),2,numel(t))];
end
if isempty(args.dfdthan)
    data.dfdthan = [];
else
    data.dfdthan = @(t,x,p) args.dfdthan(t,x,p(1:end-2,:));
end
assert(~isempty(args.pnames), 'Om should include as a system parameter');
data.pnames  = args.pnames;
Omidx = find(strcmp(args.pnames(:),'om_ext'));
data.Omidx = Omidx; 
% data = coco_func_data(data);

end