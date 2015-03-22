% SHWFS_PLOT_DELTAS.
%   [DELTAS] = SHWFS_PLOT_DELTAS_QUIVER(IMG, SHSTRUCT, REF2).
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function [deltas, moved] = shwfs_plot_deltas_quiver(img, shstruct, ref2)

% flen = shstruct.flength;
% ps = shstruct.camera_pixsize;
% pupr = shstruct.pupil_radius_m;
% sar = shstruct.sa_radius_m;


sc = 1e3;
k = sc*shstruct.camera_pixsize;
% ordgrid = k*shstruct.ord_sqgrid;
centres = k*shstruct.centres;
[deltas, moved] = shwfs_get_deltas(img, shstruct);
% moved = k*moved;

if exist('ref2', 'var')
    ref = ref2;
else
    ref = zeros(size(deltas));
end

pdeltas = deltas - ref;
quiver(centres(: ,1), centres(:, 2), ...
    pdeltas(:, 1), pdeltas(:, 2));
axis equal;
xlabel('mm');
ylabel('mm');
title(num2str(mean(deltas)));

end

