function plot_torus(toid, run, lab, outdof, varargin)
% Plot torus
% toid - the instance of torus, a typical used one is ''
% run  - the id of run
% lab  - the label of solution
% fac  - fraction of plot

if nargin<5
    fac= 1;
else
    fac = varargin{1};
end

ndof = numel(outdof);
assert(ndof<4, 'visualization of 4 or higher dimensional torus is not supported');
assert(ndof>1, 'the dimension of outdof should be larger than one');

[sol, ~] = tor_read_solution(toid, run, lab);
tube = sol.xbp; % [nt dim nsegs+1]
[nt,~,nsegs] = size(tube);
M    = ceil(nt*fac);
tube = permute(tube, [1,3,2]);
tube = tube(1:M,:,:); % a fraction of torus
if ndof<3
    % plot of x1-t-x2
    tbp = repmat(sol.tbp, [1,nsegs]);
    tbp = tbp(1:M,:);
    figure; hold on
    surf(tube(:,:,outdof(1)), tbp, tube(:,:,outdof(2)), 'FaceColor', 0.9*[1 1 1], 'FaceAlpha', 0.7, ...
        'MeshStyle', 'column', 'LineStyle', '-', 'EdgeColor', 0.6*[1 1 1], ...
        'LineWidth', 0.5);
    plot3(tube(1,:,outdof(1)), zeros(nsegs,1), tube(1,:,outdof(2)), 'LineStyle', '-', 'LineWidth', 2, ...
        'Color', 'black', 'Marker', '.', 'MarkerSize', 12);
    plot3(tube(end,:,outdof(1)), tbp(end)*ones(nsegs,1), tube(end,:,outdof(2)), 'LineStyle', '-', 'LineWidth', 2, ...
        'Color', 'blue', 'Marker', '.', 'MarkerSize', 12);
    view([50 15]); grid on
    xlabel(['$x_\mathrm{',num2str(outdof(1)),'}$'],'interpreter','latex','FontSize',14);
    ylabel('$t$','interpreter','latex','FontSize',14);
    zlabel(['$x_\mathrm{',num2str(outdof(2)),'}$'],'interpreter','latex','FontSize',14);
    title(['$\omega_1=',num2str(sol.p(end-2)),', \omega_2=',num2str(sol.p(end-1)),'$'],...
        'interpreter','latex','FontSize',14);
    hold off
else
    % plot of x1-x2-x3
    figure; hold on
    surf(tube(:,:,outdof(1)), tube(:,:,outdof(2)), tube(:,:,outdof(3)), 'FaceColor', 0.9*[1 1 1], 'FaceAlpha', 0.7, ...
        'MeshStyle', 'column', 'LineStyle', '-', 'EdgeColor', 0.6*[1 1 1], ...
        'LineWidth', 0.5);
    plot3(tube(1,:,outdof(1)), tube(1,:,outdof(2)), tube(1,:,outdof(3)), 'LineStyle', '-', 'LineWidth', 2, ...
        'Color', 'black', 'Marker', '.', 'MarkerSize', 12);
    plot3(tube(end,:,outdof(1)), tube(end,:,outdof(2)), tube(end,:,outdof(3)), 'LineStyle', '-', 'LineWidth', 2, ...
        'Color', 'blue', 'Marker', '.', 'MarkerSize', 12);
    view([50 15]); grid on
    xlabel(['$x_\mathrm{',num2str(outdof(1)),'}$'],'interpreter','latex','FontSize',14);
    ylabel(['$x_\mathrm{',num2str(outdof(2)),'}$'],'interpreter','latex','FontSize',14);
    zlabel(['$x_\mathrm{',num2str(outdof(3)),'}$'],'interpreter','latex','FontSize',14);
    title(['$\omega_1=',num2str(sol.p(end-2)),', \omega_2=',num2str(sol.p(end-1)),'$'],...
        'interpreter','latex','FontSize',14);
    hold off
end

end
