function prob = ode_TR2tor(prob, oid, varargin)
%ODE_TR2tor   Switch to branch of tori at torus (TR) bifurcation.
%
% PROB = ODE_TR2tor(PROB, OID, VARARGIN)
% VARARGIN = { RUN [SOID] LAB [OPTS] }
%
% Start a continuation of quasiperiodic orbits emanating from a torus bifurcation
% that was obtained and saved to dis in a previous continuation along a
% branch of periodic orbits with name RUN. To start from a saved TR
% bifurcation, at least the name RUN of the continuation run and the
% solution label LAB must be given. The label LAB must be the label of a
% TR bifurcation points.
%
% The arguments and their meaning are identical to ODE_PO2PO.
%
% PROB : Continuation problem structure.
% OID  : Target object instance identifier (string).
% RUN  : Run identifier (string or cell-array of strings).
% SOID : Source object instance identifier (string, optional).
% LAB  : Solution label (integer).
% 
% See also: ODE_TOR2TOR, TOR_READ_SOLUTION

% Copyright (C) MINGWU LI

grammar   = 'RUN [SOID] LAB [NSEG]';
args_spec = {
     'RUN', 'cell', '{str}',  'run',  {}, 'read', {}
    'SOID',     '',   'str', 'soid', oid, 'read', {}
     'LAB',     '',   'num',  'lab',  [], 'read', {}
     'NSEG',    '',   'num',  'nseg', [], 'read', {}
  };
opts_spec = [];
[args, ~] = coco_parse(grammar, args_spec, opts_spec, varargin{:});

if isempty(args.nseg)
    N = 10;
else
    N = args.nseg;
end

% recover trajectory of variational eqs
prob0 = coco_prob();
prob0 = ode_po2po(prob0, args.soid, args.run, args.lab);
ftest = coco_get_id(args.soid, 'po.orb.coll.test'); % Create toolbox instance identifier
fdata = coco_get_func_data(prob0, ftest, 'data'); clear prob0;
M1    = fdata.coll_tst.M(fdata.coll_tst.M1_idx,:);
M0    = fdata.coll_tst.M(fdata.coll_tst.M0_idx,:);
M     = M1/M0;
[vs,d] = eig(M);
d      = diag(d);

% extract v, a and b from sol.var
[sol, ~] = po_read_solution(args.soid, args.run, args.lab);
v = sol.var.v;
a = sol.tr.u0(1);
b = sol.tr.u0(2);
assert(min(abs(d-(a+1j*b)))<1e-3*abs(a+1j*b),...
    'stored TR solution has inconsistency');
if size(v,2)==2
    vR = v(:,1);
    vI = v(:,2);
else
    idx = find(imag(d)>0);
    vR  = real(vs(:,idx));
    vI = imag(vs(:,idx));
    th = atan2(2*vR'*vI,vI'*vI-vR'*vR);
    vr = exp(0.5*th*1j)*(vR+1j*vI); % rotated eigenvector
    vR = real(vr);
    vI = imag(vr);
    if abs(a+1j*b-d(idx))>1e-3*abs(a+1j*b)
        a = real(d(idx));
        b = imag(d(idx));
    end
end

alpha = atan2(b,a);
om2 = 2*pi/sol.T;
t0  = sol.tbp;
xbp = sol.xbp;
om1 = alpha*om2/(2*pi);
varrho = om1/om2;

% traj for om1
th1  = ((1:2*N+1)-1)*2*pi/(2*N+1);
cth1 = cos(th1+om1*t0);
sth1 = sin(th1+om1*t0);

% traj for om2
dim  = fdata.coll_seg.int.dim;
Mt   = fdata.coll_tst.M;
Mt   = Mt/M0;
vt   = Mt*(vR+1j*vI);
vt   = reshape(vt, [dim,numel(vt)/dim]);
vt   = vt(:,fdata.coll_seg.maps.tbp_idx);
rot  = exp(-1j*alpha*(t0-t0(1))/sol.T);
rot  = repmat(transpose(rot),[dim,1]);
vt   = rot.*vt;           % time in column direction
vt   = transpose(vt);     % time in row direction
Rvt  = real(vt);
Ivt  = imag(vt);

% initial torus
x0 = zeros(numel(t0),dim,2*N+1);
for i=1:2*N+1
    xi = repmat(cth1(:,i),[1,dim]).*Rvt-repmat(sth1(:,i),[1,dim]).*Ivt;
    xi = 1e-4*xi+xbp; % perturbed + mean
    x0(:,:,i) = xi;
end

figure;
xinit = x0(1,:,:);
xinit = reshape(xinit,[dim,2*N+1]);
plot3(xinit(1,:),xinit(2,:),xinit(3,:),'ro'); hold on
xfinl = x0(end,:,:);
xfinl = reshape(xfinl,[dim,2*N+1]);
plot3(xfinl(1,:),xfinl(2,:),xfinl(3,:),'bs'); hold on

p0 = sol.p;

torargs = {fdata.fhan fdata.dfdxhan fdata.dfdphan fdata.dfdthan...
    t0 x0 [fdata.pnames(:)',{'om1'},{'om2'},{'varrho'}]...
    [p0' om1 om2 varrho]};
prob = ode_isol2tor(prob, oid, torargs{:});

end