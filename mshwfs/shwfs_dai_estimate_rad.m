% SHWFS_DAI_ESTIMATE_RAD.
%   [Z, ER, S, SE, RER] = SHWFS_DAI_ESTIMATE_RAD(IMG, SHSTRUCT, LAMBDA)
%   estimates the Zernike coefficients in [rad].
%   Z estimated Zernike coefficients [rad]
%   ER error [m]
%   S deltas [m]
%   SE reconstructed slopes
%   RER relative error
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function [z, er, s, se, rer] = shwfs_dai_estimate_rad(img, shstruct, ...
    lambda)

flen = shstruct.flength;
ps = shstruct.camera_pixsize;

t = ps*shwfs_get_deltas(img, shstruct);
s = t(:);

zrad = (1/flen)*(shstruct.dai_pE1*s);

se = flen*(shstruct.dai_E1)*zrad;
er = s - se;
rer = (1e-6 + s - se)./(1e-6 + s);

z = ((2*pi)/(lambda))*zrad;

end

