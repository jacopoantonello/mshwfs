% SHWFS_PLOT_DELTAS.
%   [DELTAS] = SHWFS_PLOT_DELTAS(IMG, SHSTRUCT).
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function [deltas] = shwfs_plot_deltas(img, shstruct)

% flen = shstruct.flength;
% ps = shstruct.camera_pixsize;
% pupr = shstruct.pupil_radius_m;
% sar = shstruct.sa_radius_m;

sc = 1e3;
k = sc*shstruct.camera_pixsize;
ordgrid = k*shstruct.ord_sqgrid;
centres = k*shstruct.centres;
[deltas, moved] = shwfs_get_deltas(img, shstruct);
moved = k*moved;

plot(centres(: ,1), centres(:, 2), 'xg');
hold on;
plot(moved(: ,1), moved(:, 2), 'dr');
for i=1:size(moved, 1)
    cc = ordgrid(i, :);
    plot([centres(i, 1), moved(i, 1)], ...
        [centres(i, 2), moved(i, 2)]);
    plot(...
        [cc(1), cc(1), cc(2), cc(2), cc(1)], ...
        [cc(3), cc(4), cc(4), cc(3), cc(3)]);
end
hold off;
axis equal;
xlabel('mm');
ylabel('mm');
title(num2str(mean(deltas)));

end

