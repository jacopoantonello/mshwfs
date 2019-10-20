% ZERNIKE_RADIALDERFUN.
%   Y = ZERNIKE_RADIALDERFUN(RADIALTABLEROW) returns the derivative of the
%   radial function given a radial table row.
%
% Author: Jacopo Antonello, <jacopo@antonello.org>

function y = zernike_radialderfun(radialtablerow)

radc = radialtablerow(1);
rads = radialtablerow(2);

if radc == 0 && rads == 0
    y = @(x) 0*x;
elseif radc ~= 0
%     y = @(x) cos(radc.*x);
    y = @(x) -sin(radc.*x).*radc;
elseif rads ~= 0
%     y = @(x) sin(rads.*x);
    y = @(x) cos(rads.*x).*rads;
else
    throw(MException('VerifyOutput:IllegalInput', 'FIXME'));
end

end
