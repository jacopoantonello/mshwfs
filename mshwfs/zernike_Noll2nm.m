% zernike_Noll2nm get Noll's and n and m indeces.
%   [n, m] = zernike_Noll2nm(zstruct, noll). Zernike polynomials are ordered
%   according to [Noll1976, Mahajan1994].
%
%   References:
%   [Noll1976] R. Noll, "Zernike polynomials and atmospheric turbulence,"
%   J. Opt. Soc. Am.  66, 207-211 (1976);
%   doi: 10.1364/JOSA.66.000207
%   [Mahajan1994] V. Mahajan, "Zernike circle polynomials and optical
%   aberrations of systems with circular pupils," Appl. Opt.  33, 8121-8124
%   (1994);
%   doi: 10.1364/AO.33.008121
%
% Author: Jacopo Antonello <jacopo.antonello@dpag.ox.ac.uk>
% Centre for Neural Circuits and Behaviour, University of Oxford

function [n, m, nollstr, nmstr] = zernike_Noll2nm(zstruct, noll)
n = zstruct.jtonmtable(noll, 1);
m = zstruct.jtonmtable(noll, 2);

if nargout >= 3
    nollstr = sprintf('$Z_{%d}$', noll);
end
if nargout >= 4
    nmstr = sprintf('$Z_{%d}^{%d}$', n, m);
end
end
