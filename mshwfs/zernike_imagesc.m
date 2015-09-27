% ZERNIKE_IMAGESC plot w=Z*c.
%   [] = ZERNIKE_IMAGESC(ZSTRUCT, C).
%
% Author: Jacopo Antonello <jacopo.antonello@dpag.ox.ac.uk>
% Centre for Neural Circuits and Behaviour, University of Oxford

function [] = zernike_imagesc(zstruct, c)
Z = zernike_eval(zstruct, c);
h = imagesc(zstruct.xx(1, :), zstruct.yy(:, 1), ...
    Z);
xlabel('x');
ylabel('y');
set(h, 'AlphaData', ~isnan(Z));
end
