% ZERNIKE_CACHE_POL evaluate Zernike polynomials over a polar grid.
%   ZSTRUCT = ZERNIKE_CACHE_POL(ZSTRUCT, TH, RH).
%
%   References:
%   [S1980] J. Wang and D. Silva, "Wave-front interpretation with Zernike
%   polynomials," Appl. Opt.  19, 1510-1518 (1980);
%   doi: 10.1364/AO.19.001510
%
% Author: Jacopo Antonello <jacopo.antonello@dpag.ox.ac.uk>
% Centre for Neural Circuits and Behaviour, University of Oxford

function zstruct = zernike_cache_pol(zstruct, th, rh)

radialtable = zstruct.radialtable;
azimtable = zstruct.azimtable;

zstruct.th = th;
zstruct.rh = rh;

% exclude points outside the unit circle
suppmap = (rh <= 1);
% suppmap = logical(ones(size(rh)));
zstruct.suppmap = suppmap;
vsuppmap = suppmap(:);
zstruct.vsuppmap = vsuppmap;
nnzsupp = nnz(suppmap);
zstruct.nnzsupp = nnzsupp;

ncoeff = zstruct.ncoeff;
nel = numel(th);
zi = zeros(nel, ncoeff);

piston = ones(size(th));
piston(~suppmap) = -Inf;
zi(:, 1) = piston(:);

for i=2:ncoeff
    radc = azimtable(i, 1);
    rads = azimtable(i, 2);
    if radc == 0 && rads == 0
        mode = polyval(radialtable(i, :), rh);
    elseif radc ~= 0
        mode = polyval(radialtable(i, :), rh).*...
            cos(radc.*th);
    elseif rads ~= 0
        mode = polyval(radialtable(i, :), rh).*...
            sin(rads.*th);
    else
        throw(MException('VerifyOutput:IllegalInput', 'FIXME'));
    end
    mode(~suppmap) = -Inf;
    zi(:, i) = mode(:);
end

zstruct.zi = zi;
zstruct.nel = nel;

ZtZ = zi(vsuppmap, :)'*zi(vsuppmap, :);
zstruct.ZtZ = ZtZ;

end
