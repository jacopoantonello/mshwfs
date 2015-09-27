% ZERNIKE_CACHE evaluate Zernike polynomials over a grid.
%   ZSTRUCT = ZERNIKE_CACHE(ZSTRUCT, XX, YY).
%
%   References:
%   [S1980] J. Wang and D. Silva, "Wave-front interpretation with Zernike
%   polynomials," Appl. Opt.  19, 1510-1518 (1980);
%   doi: 10.1364/AO.19.001510
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function zstruct = zernike_cache(zstruct, xx, yy)

[th, rh] = cart2pol(xx, yy);
zstruct = zernike_cache_pol(zstruct, th, rh);
zstruct.xx = xx;
zstruct.yy = yy;

end
