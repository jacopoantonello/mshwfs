% ZERNIKE_SURF plot w=Z*c.
%   [] = ZERNIKE_SURF(ZSTRUCT, C).
%
% Author: Jacopo Antonello, <jacopo@antonello.org>

function [] = zernike_surf(zstruct, c)
surf(zstruct.xx, zstruct.yy, zernike_eval(zstruct, c));
xlabel('x');
ylabel('y');
end
