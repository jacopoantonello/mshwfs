% SHWFS_CALIBRATE.
%   Script to run the calibration functions.
%   sh_flat: reference SHWFS image.
%   sh_flat_bg: dark reference SHWFS image.
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

%% background
sfigure(1);
imshow(sh_flat_bg);
title('background');
drawnow();
pause(.1);

%% flat mirror reference
sfigure(2);
imshow(sh_flat);
title('reference image');
iimin = min(sh_flat(:));
iimax = max(sh_flat(:));
fprintf('[min, max] = [%.2f %.2f]\n', iimin, iimax);

shstruct.sh_flat = sh_flat;
shstruct.sh_flat_bg = sh_flat_bg;
if exist('scflat', 'var')
    shstruct.scflat = scflat;
end

ask_confirm('continue?');
%% coarse grid with image processing
shstruct = shwfs_make_coarse_grid(shstruct);
ask_confirm('continue?');
%% finer grid
close all;
clc;

shstruct = shwfs_make_fine_grid(shstruct);
ask_confirm('continue?');
%% Dai modal wavefront estimation
close all;
clc;

shstruct = shwfs_make_dai(shstruct);
ask_confirm('continue?');
%% save results
filename = 'shstruct.mat';
save(filename, 'shstruct');
fprintf('saved %s\n', filename);
