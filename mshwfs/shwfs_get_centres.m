% SHWFS_GET_CENTRES gets the spots centres.
%   CENTRES = SH_GET_CENTRES(IMG, SHSTRUCT, MYFUNCENTROID) gets the pixel
%   coordinates of the spots from an image in doubles of the Shack-Hartmann
%   wavefront sensor. centres is stored in the (x, y) plot() reference
%   frame after imshow(). The origin is in the top left corner.
%   centres(:, 1) are the displacements in X (left to right).
%   centres(:, 2) are the displacements in Y (top to bottom).
%   Displacements are ordered according to shstruct.enumeration.
%   centres(i, 1) corresponds to the i-th spot (shstruct.enumeration(i)).
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function centres = shwfs_get_centres(img, shstruct, ...
    myfuncentroid)

nspots = shstruct.nspots;
ordgrid = shstruct.ord_sqgrid;

centres = zeros(nspots, 2);

for ith=1:nspots
    cc = ordgrid(ith, :);

    % images are height by width!
    if (shstruct.use_bg)
        subimage = img(cc(3):cc(4), cc(1):cc(2)) - ...
            shstruct.sh_flat_bg(cc(3):cc(4), cc(1):cc(2));
    else
        subimage = img(cc(3):cc(4), cc(1):cc(2));
    end
    
    iimin = min(min(subimage));
    iimax = max(max(subimage));
    level = (iimax - iimin)*shstruct.percent + iimin;

    dd = myfuncentroid(subimage, level);
    % centroid returns in column major order
    centres(ith, :) = [cc(1)+dd(2)-1, cc(3)+dd(1)-1];
end

end
