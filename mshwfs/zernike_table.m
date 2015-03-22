% ZERNIKE_TABLE create tables for zernike polynomials up to radial order N.
%   ZSTRUCT = ZERNIKE_TABLE(N). Zernike polynomials are ordered according
%   to [Noll1976, Mahajan1994].
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
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function zstruct = zernike_table(n)

tot = (n + 1)*(n + 2)/2;

radialtable = zeros(tot, n + 1);
azimtable = zeros(tot, 2);
jtonmtable = zeros(tot, 2);

radialtable(1, end) = 1;

count = 2;
for ni=1:n
    mi = rem(ni, 2);
    while mi <= ni
        if mi == 0
            radialtable(count, :) = sqrt(ni + 1)*...
                zernike_rho_n_m(ni, mi, n);
            azimtable(count, :) = [0, 0];
            jtonmtable(count, :) = [ni, 0];
            count = count + 1;
        else
            radialtable(count + 0, :) = sqrt(2*(ni + 1))*...
                zernike_rho_n_m(ni, mi, n);
            radialtable(count + 1, :) = sqrt(2*(ni + 1))*...
                zernike_rho_n_m(ni, mi, n);
            if rem(count, 2)
                azimtable(count + 0, :) = [0, mi];
                azimtable(count + 1, :) = [mi, 0];
                jtonmtable(count + 0, :) = [ni, -mi];
                jtonmtable(count + 1, :) = [ni, mi];
            else
                azimtable(count + 0, :) = [mi, 0];
                azimtable(count + 1, :) = [0, mi];
                jtonmtable(count + 0, :) = [ni, mi];
                jtonmtable(count + 1, :) = [ni, -mi];
            end
            
            count = count + 2;
        end
    
    mi = mi + 2;
    end
end

zstruct = struct();
zstruct.radialtable = radialtable;
zstruct.azimtable = azimtable;
zstruct.jtonmtable = jtonmtable;
zstruct.ncoeff = tot;

    function z = zernike_rho_n_m(n, m, ord)
        z = zeros(1, ord + 1);
        for s=0:((n - m)/2)
            z(ord + 1 - (n - 2*s)) = ...
                (((-1)^s)*factorial(n - s))/...
                (factorial(s)*factorial((n + m)/2 - s)*...
                factorial((n - m)/2 - s));
        end
    end
end
