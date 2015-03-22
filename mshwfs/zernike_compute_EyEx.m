% ZERNIKE_COMPUTE_EyEx compute Ey and Ex.
%   [Ey, Ex] = ZERNIKE_COMPUTE_EyEx(RADROW, AZIMROW, RHO_0, THETA_0, R_SA).
%   See [P1990, D1994, A2014].
%   RADROW      Zernike radial polynomial
%   AZIMROW     azimuthal order
%   THETA_0     (rho_0, theta_0) subaperture location
%   R_SA        subaperture normalised radius (0, 1]
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

function [Ey, Ex] = zernike_compute_EyEx(radrow, azimrow, ...
    rho_0, theta_0, r_sa)

% rho_0 is in [0 1]
% r_sa is in [0 1]

% Ey Ex must be multiplied with lambda*f/(2*pi*A_sa)

assert(rho_0 >= 0 && rho_0 < 1);
assert(r_sa > 0 && r_sa < 1);

rhoindefint1 = polyint([polyder(radrow) 0]);
rhoindefint2 = polyint(radrow);

theta_a = theta_0 - atan(r_sa/rho_0);
theta_b = theta_0 + atan(r_sa/rho_0);

rho_a = @(x) rho_0.*cos(x - theta_0) - ...
    sqrt((rho_0.^2).*cos(x - theta_0) + ...
    (r_sa.^2) - (rho_0.^2));
rho_b = @(x) rho_0.*cos(x - theta_0) + ...
    sqrt((rho_0.^2).*cos(x - theta_0) + ...
    (r_sa.^2) - (rho_0.^2));

rhoint1a = @(x) polyval(rhoindefint1, rho_a(x));
rhoint1b = @(x) polyval(rhoindefint1, rho_b(x));
rhoint2a = @(x) polyval(rhoindefint2, rho_a(x));
rhoint2b = @(x) polyval(rhoindefint2, rho_b(x));
psi = zernike_radialfun(azimrow);
psider = zernike_radialderfun(azimrow);

integrandx = @(x) ...
    (rhoint1b(x) - rhoint1a(x)).*psi(x).*cos(x) - ...
    (rhoint2b(x) - rhoint2a(x)).*psider(x).*sin(x);

integrandy = @(x) ...
    (rhoint1b(x) - rhoint1a(x)).*psi(x).*sin(x) + ...
    (rhoint2b(x) - rhoint2a(x)).*psider(x).*cos(x);

Ex = quad(integrandx, theta_a, theta_b);
Ey = quad(integrandy, theta_a, theta_b);

end

