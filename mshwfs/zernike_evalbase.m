% ZERNIKE_EVALBASE evaluate Z_i in polar coordinates.
%   Y = ZERNIKE_EVALBASE(ZSTRUCT, IND, RH, TH).
%   IND     base index
%   RH      rho table
%   TH      theta table
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function y = zernike_evalbase(zstruct, ind, rh, th)

radialtable = zstruct.radialtable;
azimtable = zstruct.azimtable;

if ind == 1
    y = 1;
else
    radc = azimtable(ind, 1);
    rads = azimtable(ind, 2);
    if radc == 0 && rads == 0
        y = polyval(radialtable(ind, :), rh);
    elseif radc ~= 0
        y = polyval(radialtable(ind, :), rh).*...
            cos(radc.*th);
    elseif rads ~= 0
        y = polyval(radialtable(ind, :), rh).*...
            sin(rads.*th);
    else
        throw(MException('VerifyOutput:IllegalInput', 'FIXME'));
    end
end

end
