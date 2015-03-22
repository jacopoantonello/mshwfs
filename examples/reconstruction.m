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

zcs = [0; zhatrad];
sel = 1:size(zhatrad, 1);
plot(sel, zcs(sel), 'x', 'MarkerSize', 32);
varrad = sum(zcs(2:end).^2);
strehl = exp(-sum(zcs(2:end).^2));
title(sprintf('norm(s - se) %.8f Strehl %.3f varrad %f norminf %.4f', ...
    norm(er), strehl, varrad,...
    norm(zcs(2:end), inf)));
set(gca, 'XTick', sel);
xlabel('zernike coeff');
ylabel('rad');
grid on;

figure(5);
zernike_surf(zstruct, zcs);
% view(2);
zlabel('rad');
shading interp;
