% SHWFS_MAKE_COARSE_GRID.
%   [SHSTRUCT] = SHWFS_MAKE_COARSE_GRID(SHSTRUCT). Make a coarse grid to
%   compute the centroids using the image processing toolbox.
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function [shstruct] = shwfs_make_coarse_grid(shstruct)

sh_flat_bg = shstruct.sh_flat_bg;
sh_flat = shstruct.sh_flat;

% tunable parameters
use_bg = shstruct.use_bg;
thresh = shstruct.thresh_binary_img;
npixsmall = shstruct.npixsmall;
strel_rad = shstruct.strel_rad;
shstruct.sh_flat_bg = sh_flat_bg;
radius = shstruct.coarse_grid_radius;

%% thresh = graythresh(sh_flat);
if use_bg
    bw = im2bw(sh_flat - sh_flat_bg, thresh);
else
    bw = im2bw(sh_flat, thresh);
end
sfigure(5);
imshow(bw);
title('binary image');
drawnow();
pause(.1);

%% remove small objects
bw = bwareaopen(bw, npixsmall);
%% remove edges
se = strel('disk',strel_rad);
bw = imclose(bw, se);
%%
cc = bwconncomp(bw, 4);
s = regionprops(cc, 'Centroid');

nspots = length(s);
hold on;
for k = 1:nspots
    c = s(k).Centroid;
    plot(c(1), c(2), 'ro');
end

squaregrid = zeros(nspots, 4);

sfigure(6);
imshow(sh_flat);
hold on;
for k = 1:nspots
    c = s(k).Centroid;
    plot(c(1), c(2), 'ro');
end

for k=1:nspots
    c = s(k).Centroid;

    c = round(c);
    minx = c(1) - radius;
    maxx = c(1) + radius;
    miny = c(2) - radius;
    maxy = c(2) + radius;

    box = [minx, maxx, miny, maxy];
    squaregrid(k, :) = box;
    sfigure(6);
    hold on;
    rectangle('Position', [minx, miny, maxx-minx+1, maxy-miny+1], ...
        'LineWidth', 2, 'EdgeColor', 'b');
    sfigure(15);

    % COORDINATES
    % - image is stored in column major order
    % - after imshow, the origin for plot() is in the topleft corner,
    %   x1 points right, x2 points down
    % - grid & centres are stored in the plot coordinate system
    % - subimages must be access sh_flat(box(3):box(4), box(1):box(2))
    % - pupil coordinates are canonical xy axes, x right, y up
    % - zernike_surf & *dai* xy coordinates are refered to the pupil,
    %   not to the plot() axes

    % image is height times width!
    subsfigure = sh_flat(box(3):box(4), box(1):box(2));
    imshow(subsfigure);
    pause(0.01);
end

shstruct.nspots = nspots;
% [minx, miny, maxx-minx+1, maxy-miny+1]
% image plot coords
shstruct.squaregrid = squaregrid;

fprintf('$ selected nspots = %d\n', shstruct.nspots);
fprintf('$ the red circles/blue boxes in Fig.6 must not overlap!\n');
fprintf('$ tune the image processing parameters to get more or less spots\n');


end

