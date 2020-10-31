function plot_torus(toid, run, lab, fac)
% Plot torus
% toid - the instance of torus, a typical used one is ''
% run  - the id of run
% lab  - the label of solution
% fac  - fraction of plot

if nargin<4
  fac=0.75;
end

[sol, ~] = tor_read_solution(toid, run, lab);
tube = sol.xbp; % [nt dim nsegs+1]
[nt,dim,nsegs] = size(tube);
M    = ceil(nt*fac);
tube = permute(tube, [1,3,2]);
tube = tube(1:M,:,:); % a fraction of torus
if dim<3
    % plot of x1-t-x2
    tbp = repmat(sol.tbp, [1,nsegs]);
    tbp = tbp(1:M,:);
    figure; hold on
    surf(tube(:,:,1), tbp, tube(:,:,2), 'FaceColor', 0.9*[1 1 1], 'FaceAlpha', 0.7, ...
        'MeshStyle', 'column', 'LineStyle', '-', 'EdgeColor', 0.6*[1 1 1], ...
        'LineWidth', 0.5);
    plot3(tube(1,:,1), zeros(nsegs,1), tube(1,:,2), 'LineStyle', '-', 'LineWidth', 2, ...
        'Color', 'black', 'Marker', '.', 'MarkerSize', 12);
    plot3(tube(end,:,1), tbp(end)*ones(nsegs,1), tube(end,:,2), 'LineStyle', '-', 'LineWidth', 2, ...
        'Color', 'blue', 'Marker', '.', 'MarkerSize', 12);
    view([50 15]); grid on
    xlabel('$x_1$','interpreter','latex','FontSize',14);
    ylabel('$t$','interpreter','latex','FontSize',14);
    zlabel('$x_2$','interpreter','latex','FontSize',14);
    hold off
else
    % plot of x1-x2-x3
    figure; hold on
    surf(tube(:,:,1), tube(:,:,2), tube(:,:,3), 'FaceColor', 0.9*[1 1 1], 'FaceAlpha', 0.7, ...
        'MeshStyle', 'column', 'LineStyle', '-', 'EdgeColor', 0.6*[1 1 1], ...
        'LineWidth', 0.5);
    plot3(tube(1,:,1), tube(1,:,2), tube(1,:,3), 'LineStyle', '-', 'LineWidth', 2, ...
        'Color', 'black', 'Marker', '.', 'MarkerSize', 12);
    plot3(tube(end,:,1), tube(end,:,2), tube(end,:,3), 'LineStyle', '-', 'LineWidth', 2, ...
        'Color', 'blue', 'Marker', '.', 'MarkerSize', 12);
    view([50 15]); grid on
    xlabel('$x_1$','interpreter','latex','FontSize',14);
    ylabel('$x_2$','interpreter','latex','FontSize',14);
    zlabel('$x_3$','interpreter','latex','FontSize',14);
    hold off
end

end
