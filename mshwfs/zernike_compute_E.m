% ZERNIKE_COMPUTE_E computes matrix E.
%   E = ZERNIKE_COMPUTE_E(ZSTRUCT, SHSTRUCT). Compute
%   Guang-Ming Dai's reconstruction matrix. See [P1990, D1994, A2014].
%   shstruct.pupil_radius_m    pupil radius [m]
%   shstruct.sa_radius_m       subapertura radius [m]
%
%   References:
%   [P1990] J. Primot, G. Rousset, and J. Fontanella, "Deconvolution from
%   wave-front sensing: a new technique for compensating
%   turbulence-degraded images," J. Opt. Soc. Am. A  7, 1598-1608 (1990);
%   doi: 10.1364/JOSAA.7.001598
%   [D1994] G.-M. Dai, "Modified Hartmann-Shack wavefront sensing and
%   iterative wavefront reconstruction," Proc. SPIE 2201, Adaptive Optics
%   in Astronomy, 562 (May 31, 1994);
%   doi: 10.1117/12.176040
%   [A2014] J. Antonello, "Optimisation-based wavefront sensorless adaptive
%   optics for microscopy," Ph.D. thesis, Delft University of Technology
%   (2014);
%   doi: 10.4233/uuid:f98b3b8f-bdb8-41bb-8766-d0a15dae0e27See
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function E = zernike_compute_E(zstruct, shstruct)

pupil_radius_m = shstruct.pupil_radius_m;
sa_radius_m = shstruct.sa_radius_m;
ncoefs = zstruct.ncoeff;
nspots = shstruct.nspots;
ord_centres = shstruct.ord_centres;
pixsize = shstruct.camera_pixsize;

radtab = zstruct.radialtable;
azimtab = zstruct.azimtable;

E = zeros(2*shstruct.nspots, ncoefs);

sac = shstruct.pupil_centre_pix;
rho_sa = sa_radius_m/pupil_radius_m;

kk = pupil_radius_m/(pi*(sa_radius_m^2));

for i=1:nspots
    dx1dx2 = (ord_centres(i, :) - sac)*pixsize;
    rho_0 = norm(dx1dx2)/(pupil_radius_m);
    % pupil is in canonical coordinates, x points right, y points up
	% ord_centres is in plot coordinates x1 points right, x2 points down
	% atan2(y, x), dx = dx1, dy = -dx2
    theta_0 = atan2(-dx1dx2(2), dx1dx2(1));
    if rho_0 > 1
        throw(MException('VerifyOutput:IllegalInput', ...
            'The aperture radius is too small, use a larger pupil_radius_m'));
    end
    
    for zi=2:ncoefs
        radtabrow = radtab(zi, :);
        azimtabrow = azimtab(zi, :);
        
        [ey, ex] = zernike_compute_EyEx(...
            radtabrow, azimtabrow, ...
            rho_0, theta_0, rho_sa);
        % centres, boxes and deltas are in the plot() coordinate system
        % after imshow()!
        % deltas(:) will be [x1; x2] where x1 goes left to right and x2
        % goes top to bottom. So convert again to plot coordinate system.
        % dx1 = kk*dx, dx2 = -kk*dy
        E(i, zi) = kk*ex;
        E(i + nspots, zi) = -kk*ey;
    end
end

end
