% Example of wavefront reconstruction. After the calibration file
% shstruct.mat has been created, you can estimate the wavefront from a
% SHWFS image (img).

clear all;
clc;
close all;
%%
addpath('../mshwfs/');
addpath('./data/');  % example data
%%
% load the calibration
load shstruct;

% load an aberrated SHWFS image
load img.mat; % or img = double(imread(pic))/shstruct.maxinteger;

% estimate the wavefront
[zhatrad, er] = shwfs_dai_estimate_rad(img, shstruct, 632.8e-9);

% plot the results
zstruct = shstruct.dai_zstruct;
dd = linspace(-1, 1, 80);
[xx, yy] =  meshgrid(dd, dd);
zstruct = zernike_cache(zstruct, xx, yy);

sfigure(1);

subplot(2, 2, 1:2);
zcs = [0; zhatrad];
sel = 1:size(zhatrad, 1);
% plot(sel, zcs(sel), 'x', 'MarkerSize', 32);
plot(sel, zcs(sel), 'Marker', 'x');

rms1 = norm(zcs(2:end));
strehl = exp(-rms1.^2);
title(sprintf('strehl=%.3f rms=%.2f norm(er)=%.2f', strehl, rms1, ...
    norm(er)));
set(gca, 'XTick', sel);
xlabel('Z_i');
ylabel('rad');
grid on;

subplot(2, 2, 3);
zernike_surf(zstruct, zcs);
zlabel('rad');
shading interp;

subplot(2, 2, 4);
zernike_imagesc(zstruct, zcs);
axis equal;
axis off;
title(sprintf('%d Zernike polynomials', zstruct.ncoeff));
