function J = net_DFDT(t, x, p)
%VDP_DFDT   'coll'-compatible encoding of Jacobian of langford vector field w.r.t. time

x1 = x(1,:);
om = p(1,:);
a  = p(3,:);

J = zeros(2,numel(x1));
J(2,:) = -om.*a.*sin(om.*t);

    [m, n] = size(x);
    f  = @(x,p) data.fhan(x(1,:), p(1:m,:), p(m+1:end,:));
    xp = [ x ; p ];
    Jt = reshape(coco_ezDFDX('f(x,p)v', f, t, xp), [m n]);

end
