% ZERNIKE_RADIALEVAL.
%   Y = ZERNIKE_RADIALEVAL(RADTAB, THETA).
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function y = zernike_radialeval(radtab, theta)

radialtable = zstruct.radialtable;
azimtable = zstruct.azimtable;

[th rh] = cart2pol(xx, yy);

zstruct.xx = xx;
zstruct.yy = yy;
zstruct.th = th;
zstruct.rh = rh;

suppmap = (rh <= 1);
zstruct.suppmap = suppmap;

ncoeff = zstruct.ncoeff;
nel = numel(xx);
zi = zeros(nel, ncoeff);

piston = ones(size(xx));
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

end
