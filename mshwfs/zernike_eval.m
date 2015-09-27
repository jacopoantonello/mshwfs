% ZERNIKE_EVAL evaluate w=Z*c.
%   [W, WV] = ZERNIKE_EVAL(ZSTRUCT, ZC).
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function [w, wv] = zernike_eval(zstruct, zc)
if nargout == 1
    w = reshape(zstruct.zi*zc, size(zstruct.th));
elseif nargout == 2
    w =[];
    wv = zstruct.zi*zc;
end

end
