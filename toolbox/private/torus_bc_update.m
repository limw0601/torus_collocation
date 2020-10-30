function data = torus_bc_update(data, T0, T, x0, x1, p)

if data.nOmega<1.5
        coeffs = data.F*x0;
        coeffs = reshape(coeffs,[data.dim,2*data.N+1]);
        f00    = 2*pi*sum(repmat((1:data.N),[data.dim,1]).*coeffs(:,3:2:end),2); % 2\pi\sum kb_k
        data.x00 = x0(1:data.dim);
        data.f00 = f00;
end

if data.nOmega<0.5
    data.x0 = x0(1:data.dim);
    data.f0 = data.fhan(T0,data.x0,p);
end

% n  = numel(x0);
% q  = numel(p);
% data.J = [sparse(n,1), speye(n,n), -speye(n,n), sparse(n,q);
% sparse(1,1), data.f0, sparse(1,n), sparse(1,q)];

end