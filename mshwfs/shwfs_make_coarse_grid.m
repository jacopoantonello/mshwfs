% SHWFS_MAKE_COARSE_GRID.
%   [SHSTRUCT] = SHWFS_MAKE_COARSE_GRID(SHSTRUCT). Make a coarse grid to
%   compute the centroids using the image processing toolbox.
%
% Author: Jacopo Antonello, <jack@antonello.org>

function [shstruct] = shwfs_make_coarse_grid(shstruct, wait)

sh_flat_bg = shstruct.sh_flat_bg;
sh_flat = shstruct.sh_flat;

% tunable parameters
use_bg = shstruct.use_bg;
thresh = shstruct.thresh_binary_img;
npixsmall = shstruct.npixsmall;
strel_rad = shstruct.strel_rad;
shstruct.sh_flat_bg = sh_flat_bg;
radius = shstruct.coarse_grid_radius;

% binarize
if use_bg
    bw = imbinarize(sh_flat - sh_flat_bg, thresh);
else
    bw = imbinarize(sh_flat, thresh);
end
sfigure(5);
imagesc(bw);
axis image;
axis off;
title('binary image');
drawnow();
pause(.1);

% remove small objects
bw = bwareaopen(bw, npixsmall);
% remove edges
se = strel('disk',strel_rad);
bw = imclose(bw, se);

% detect spots
cc = bwconncomp(bw, 4);
s = regionprops(cc, 'Centroid');

nspots = length(s);
hold on;
for k = 1:nspots
    c = s(k).Centroid;
    plot(c(1), c(2), 'ro');
end

squaregrid = zeros(nspots, 4);

f6 = sfigure(6);
imagesc(sh_flat);
axis image;
axis off;
hold on;
for k = 1:nspots
    c = s(k).Centroid;
    plot(c(1), c(2), 'ro');
end

squaregridmap = ones(1, nspots);
for k=1:nspots
    c = s(k).Centroid;

    c = round(c);
    minx = c(1) - radius;
    maxx = c(1) + radius;
    miny = c(2) - radius;
    maxy = c(2) + radius;

    box = [minx, maxx, miny, maxy];
    squaregrid(k, :) = box;
    f6 = sfigure(6);
    hold on;
    rectangle('Position', [minx, miny, maxx-minx+1, maxy-miny+1], ...
        'LineWidth', 2, 'EdgeColor', 'y');

    sfigure(15);
    % COORDINATES
    % - image is stored in column major order
    % - after imshow, the origin for plot() is in the topleft corner,
    %   x1 points right, x2 points down
    % - grid & centres are stored in the plot coordinate system
    % - subimages must be accessed sh_flat(box(3):box(4), box(1):box(2))
    % - pupil coordinates are canonical xy axes, x right, y up
    % - zernike_surf & *dai* xy coordinates are refered to the pupil,
    %   not to the plot() axes

    % image is height times width!
    subsfigure = sh_flat(box(3):box(4), box(1):box(2));
    imagesc(subsfigure);
    axis image;
    axis off;
    pause(0.01);
end

f6 = sfigure(6);
title('click to disable boxes');
set(f6, 'WindowButtonDownFcn', @markbox);

fprintf('$ 1) the red circles/yellow boxes in Fig.6 must not overlap\n');
fprintf('$ 2) if you get too many overlaps you may need to tune the\n');
fprintf('$    image processing parameters and try again\n');
fprintf('$ 3) you can enable/disable a box by clicking on it\n');
if exist('wait', 'var') && wait
    ask_confirm('continue?');
end

% remove disabled spots
shstruct.squaregrid = squaregrid(logical(squaregridmap), :);
shstruct.nspots = size(shstruct.squaregrid, 1);

    function [] = markbox(myobj, ~)
        mypos = myobj.CurrentAxes.CurrentPoint(1, 1:2);
        mypos = [mypos(1), mypos(1), mypos(2), mypos(2)];
        myhit = kron(ones(nspots, 1), mypos) - squaregrid;
        myind = find(...
            (myhit(:, 1) > 0).*(myhit(:, 2) < 0).*...
            (myhit(:, 3) > 0).*(myhit(:, 4) < 0));
        for myi=1:numel(myind)
            squaregridmap(myind(myi)) = ~squaregridmap(myind(myi));
            if squaregridmap(myind(myi))
                mycolour = 'y';
            else
                mycolour = [0.3, 0.3, 0.0];
            end
            f6 = sfigure(6);
            hold on;
            mybox = squaregrid(myind(myi), :);
            mybox = [...
                mybox(1), mybox(3), ...
                mybox(2) - mybox(1) + 1, mybox(4) - mybox(3) + 1];
            rectangle(...
                'Position', mybox, 'LineWidth', 2, 'EdgeColor', mycolour);
        end
    end
end
