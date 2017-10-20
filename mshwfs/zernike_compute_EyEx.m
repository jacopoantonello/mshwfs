% ZERNIKE_COMPUTE_EyEx compute Ey and Ex.
%   [Ey, Ex] = ZERNIKE_COMPUTE_EyEx(RADROW, AZIMROW, R, GAMMA, RBAR).
%   See [P1990, D1994, A2014].
%   RADROW      Zernike radial polynomial
%   AZIMROW     azimuthal order
%   R           subaperture location
%   GAMMA       subaperture location
%   RBAR        subaperture normalised radius (0, 1]
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

function [Ey, Ex] = ...
    zernike_compute_EyEx(radrow, azimrow, r, gamma, rbar)

% r is in [0 1]
% rbar is in [0 1]

% Ey Ex must be multiplied with lambda*f/(2*pi*A_sa)

assert(r >= 0 && r < 1);
assert(rbar > 0 && rbar < 1);

rhoindefint1 = polyint([polyder(radrow) 0]);
rhoindefint2 = polyint(radrow);

if r > rbar
    thetas = gamma + ...
        [acos(sqrt(r^2 - rbar^2)/r), - acos(sqrt(r^2 - rbar^2)/r)];

    theta_a = min(thetas);
    theta_b = max(thetas);
    assert(theta_b > theta_a);

    rho_a = @(x) r*cos(x - gamma) - ...
        sqrt(r^2.*cos(x - gamma).^2 - (r^2 - rbar^2));
    rho_b = @(x) r*cos(x - gamma) + ...
        sqrt(r^2.*cos(x - gamma).^2 - (r^2 - rbar^2));
else
    theta_a = 0;
    theta_b = 2*pi;

    rho_a = @(x) 0*x;
    rho_b = @(x) r*cos(x - gamma) + ...
        sqrt(r^2.*cos(x - gamma).^2 - (r^2 - rbar^2));
end


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

Ex = integral(integrandx, theta_a, theta_b);
Ey = integral(integrandy, theta_a, theta_b);

end

