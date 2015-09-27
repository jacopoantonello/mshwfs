% SHWFS_MAKE_FINE_GRID.
%   [SHSTRUCT] = SHWFS_MAKE_FINE_GRID(SHSTRUCT). Make a fine grid to
%   compute the centroids using the image processing toolbox.
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function [shstruct] = shwfs_make_fine_grid(shstruct)

sh_flat = shstruct.sh_flat;

%% get centres with coarse grid
nspots = shstruct.nspots;
centres = zeros(nspots, 2);
img = shstruct.sh_flat;

for i=1:nspots
    cc = shstruct.squaregrid(i, :);

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

    dd = shstruct.centroid(subimage, level);
    centres(i, :) = [cc(1)+dd(2)-1, cc(3)+dd(1)-1];
end
%%
shstruct.centres = centres;
fprintf('any non finite? %d\n', any(any(isfinite(centres) == 0)));
fprintf('min(sh_flat(:)) %f\n', min(sh_flat(:)));
fprintf('max(sh_flat(:)) %f\n', max(sh_flat(:)));
fprintf('min(exp(sh_flat(:))) %f\n', min(exp(sh_flat(:))));
fprintf('max(exp(sh_flat(:))) %f\n', max(exp(sh_flat(:))));
%% guess central spot
norms = zeros(nspots, nspots);
for i=1:nspots
    for j=1:nspots
        norms(i, j) = norm(centres(i, :) - centres(j, :));
    end
end
lnorms = sum(norms, 2);
[~, icentralspot] = min(lnorms);
% estimate radius
mins = zeros(nspots, 1);
for i=1:nspots
    [~, sel] = sort(norms(i, :));
    mins(i) = norms(i, sel(2));
end
radius = mean(mins)/2*shstruct.multiply_est_radius;

sfigure(7);
plot(mins, 'o');
xlabel('spot number');
ylabel('radius');
drawnow()
pause(.1);

% estimate pupil radius
shstruct.est_pupil_radius_m = ...
    max(norms(icentralspot, :))*...
    shstruct.camera_pixsize;

shstruct.squaregrid_coarse = shstruct.squaregrid;
shstruct.squaregrid_radius = radius;

for i=1:nspots
    c = centres(i, :);
    minx = c(1) - radius;
    maxx = c(1) + radius;
    miny = c(2) - radius;
    maxy = c(2) + radius;
    shstruct.squaregrid(i, :) = round([minx, maxx, miny, maxy]);
end
%% draw fine grid
grid = shstruct.squaregrid;

sfigure(8);
imshow(sh_flat);
hold on;
spotxy = centres(icentralspot, :);
plot(spotxy(1), spotxy(2), 'yo');

title('fine grid');
for i=1:nspots
    cc = grid(i, :);
    rectangle('Position', ...
        [cc(1), cc(3), cc(2)-cc(1)+1, cc(4)-cc(3)+1], ...
        'LineWidth', 1, 'EdgeColor', 'b');
    plot(centres(i, 1), centres(i, 2), 'xr');
    text(cc(1), cc(3), ...
        sprintf('%d', i), 'Color', 'g');
end
hold off;
%% unused, code for zonal is outdated
shstruct.enumeration = 1:shstruct.nspots;
shstruct.ord_centres = shstruct.centres(shstruct.enumeration, :);
shstruct.ord_sqgrid = zeros(size(shstruct.ord_centres, 1), 4);
shstruct.ord_sqgrid = shstruct.squaregrid(shstruct.enumeration, :);


end
