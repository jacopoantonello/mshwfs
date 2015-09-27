% SHWFS_CALIBRATE.
%   Script to run the calibration functions.
%   sh_flat: reference SHWFS image.
%   sh_flat_bg: dark reference SHWFS image.
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

mkdir(sprintf('calibration-%s', shstruct.calibration_date));
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

filename_blank = ...
    sprintf('calibration-%s/shstruct.blank.mat', ...
    shstruct.calibration_date);
ask_confirm('continue?');

save(filename_blank, 'shstruct');
fprintf('saved %s\n', filename_blank);
%% coarse grid with image processing
load(filename_blank);
shstruct = shwfs_make_coarse_grid(shstruct);
filename_coarse = ...
    sprintf('calibration-%s/shstruct.coarse.mat', ...
    shstruct.calibration_date);
ask_confirm('continue?');

save(filename_coarse, 'shstruct');
fprintf('saved %s\n', filename_coarse);
%% finer grid
close all;
clc;

load(filename_coarse);
shstruct = shwfs_make_fine_grid(shstruct);
filename_fine = ...
    sprintf('calibration-%s/shstruct.fine.mat', ...
    shstruct.calibration_date);
ask_confirm('continue?');

save(filename_fine, 'shstruct');
fprintf('saved %s\n', filename_fine);
%% Dai modal wavefront estimation
close all;
clc;

load(filename_fine);
shstruct = shwfs_make_dai(shstruct);
filename_dai = ...
    sprintf('calibration-%s/shstruct.dai.mat', ...
    shstruct.calibration_date);
ask_confirm('continue?');

save(filename_dai, 'shstruct');
fprintf('saved %s\n', filename_fine);
%% save results
filename = 'shstruct.mat';
save(filename, 'shstruct');
fprintf('saved %s\n', filename);
