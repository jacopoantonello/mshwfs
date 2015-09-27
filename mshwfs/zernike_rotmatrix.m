% ZERNIKE_ROTMATRIX make a matrix to rotate the pupil.
%   [R] = ZERNIKE_ROTMATRIX(ZSTRUCT, ALPHA).
%
%   Example:
%     zs = zernike_table(6);
%     dd = linspace(-1, 1, 80);
%     [xx, yy] =  meshgrid(dd, dd);
%     zs = zernike_cache(zs, xx, yy);
% 
%     alpha = pi/6;
%     zc = (logspace(1, 0, zs.ncoeff)').*randn(zs.ncoeff, 1);
% 
%     sfigure();
%     subplot(2, 2, 1);
%     zernike_imagesc(zs, zc);
%     axis equal;
%     axis off;
%     subplot(2, 2, 2);
%     plot(zc, 'Marker', 'x');
%     grid on;
% 
%     zc1 = zernike_rotmatrix(zs, alpha)*zc;
%     subplot(2, 2, 3);
%     zernike_imagesc(zs, zc1);
%     axis equal;
%     axis off;
%     subplot(2, 2, 4);
%     plot(zc1, 'Marker', 'x');
%     grid on;
%
% Author: Jacopo Antonello <jacopo.antonello@dpag.ox.ac.uk>
% Centre for Neural Circuits and Behaviour, University of Oxford

function [R] = zernike_rotmatrix(zstruct, alpha)
jtonmtable = zstruct.jtonmtable;
ncoeff = size(jtonmtable, 1);
R = zeros(ncoeff, ncoeff);
for i=1:size(jtonmtable, 1)
    n = jtonmtable(i, 1);
    m = jtonmtable(i, 2);
    if m == 0
        R(i, i) = 1;
    elseif m > 0
        inminm = find(sum(abs(jtonmtable - ...
            kron(ones(ncoeff, 1), [n, -m])), 2) == 0);
        assert(numel(inminm) == 1);
        R(i, i) = cos(m*alpha);
        R(i, inminm) = sin(m*alpha);
    elseif m < 0
        inminm = find(sum(abs(jtonmtable - ...
            kron(ones(ncoeff, 1), [n, -m])), 2) == 0);
        assert(numel(inminm) == 1);
        R(i, inminm) = -sin(abs(m)*alpha);
        R(i, i) = cos(abs(m)*alpha);
    end
end
end
