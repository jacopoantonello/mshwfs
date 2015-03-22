% SHWFS_MAKE_DAI.
%   [SHSTRUCT] = SHWFS_MAKE_DAI(SHSTRUCT). Setup Guang-Ming Dai's
%   reconstruction matrix. See [D1994, A2014].
%
%   References:
%   [D1994] G.-M. Dai, "Modified Hartmann-Shack wavefront sensing and
%   iterative wavefront reconstruction," Proc. SPIE 2201, Adaptive Optics
%   in Astronomy, 562 (May 31, 1994);
%   doi: 10.1117/12.176040
%   [A2014] J. Antonello, "Optimisation-based wavefront sensorless adaptive
%   optics for microscopy," Ph.D. thesis, Delft University of Technology
%   (2014);
%   doi: 10.4233/uuid:f98b3b8f-bdb8-41bb-8766-d0a15dae0e27
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function [shstruct] = shwfs_make_dai(shstruct)

ncoefs = shstruct.dai_n_zernike;
zstruct = zernike_table(ncoefs);

shstruct.pupil_centre_pix = mean(shstruct.ord_centres, 1);
subapradius_m = shstruct.sa_radius_m;

sfigure(18);
imshow(shstruct.sh_flat);
hold on;
l = linspace(0, 2*pi);
r = subapradius_m/shstruct.camera_pixsize;
for i=1:shstruct.nspots
    c = shstruct.ord_centres(i, :);
    cc = shstruct.ord_sqgrid(i, :);
    plot(c(1), c(2), 'oy');
    plot(c(1) + r*cos(l), c(2) + r*sin(l));
    text(c(1), c(2), sprintf('%d', i), 'Color', 'r');
    rectangle('Position', ...
        [cc(1), cc(3), cc(2)-cc(1)+1, cc(4)-cc(3)+1], ...
        'LineWidth', 1, 'EdgeColor','y');
end
title('subapertures');

% centre
c = shstruct.pupil_centre_pix;
plot(c(1), c(2), 'xm', 'MarkerSize', 13);

% pupil
dists = shstruct.ord_centres - ...
    kron(ones(shstruct.nspots, 1), shstruct.pupil_centre_pix);
[~, i] = sort(sqrt(sum(dists, 2).^2));
shstruct.pupil_radius_m = norm(shstruct.ord_centres(i(end), :) - ...
    shstruct.pupil_centre_pix)*shstruct.camera_pixsize + ...
    shstruct.sa_radius_m;

r = shstruct.pupil_radius_m/shstruct.camera_pixsize;
plot(c(1) + r*cos(l), c(2) + r*sin(l), 'y');


%% [slopesleftright; slopestopbottom] = E*z
% zernike_surf & *dai* xy coordinates are refered to the pupil,
%   not to the plot() axes
fprintf('wait, computing matrices...\n');
E = zernike_compute_E(zstruct, shstruct);
fprintf('   done!\n');
shstruct.dai_E1 = E(:, 2:end);
shstruct.dai_pE1 = pinv(E(:, 2:end));
shstruct.dai_zstruct = zstruct;
E1 = shstruct.dai_E1;
fprintf('size(E1) %s\n', num2str(size(E1)));
fprintf('cond(E1) %.4f\n', cond(E1));
fprintf('rank(E1) %.4f\n', rank(E1));

end





