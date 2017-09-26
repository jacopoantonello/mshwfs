% Calibration example. Adjust the parameters of your lenslet array and use
% your SHWFS reference image.

clear;
close all;
clc;
%%
addpath('../mshwfs/');
addpath('./data/');  % example data
%% parameters
shstruct = struct();
shstruct.calibration_date = datestr(now, 'yyyymmddHHMMSS');
shstruct.use_bg = 0;               % subtract background from images
shstruct.thresh_binary_img = 0.08; % threshold for binary image
shstruct.npixsmall = 8;            % remove objects less than npixsmall
shstruct.strel_rad = 8;            % strel ratio (image processing)
shstruct.coarse_grid_radius = 12;  % radius for coarse grid
shstruct.percent = 0.2;            % threshold used in centroid
% scale estimated radius in the fine grid
shstruct.multiply_est_radius = 1/sqrt(2);
shstruct.centroid = @centroid;     % centroid algorithm

%% lenslet documentation
shstruct.totlenses = 127;
shstruct.flength = 18e-3;
shstruct.pitch = 300e-6;

%% camera documentation
shstruct.camera_pixsize = 7.4*1e-6;
shstruct.maxinteger = 2^16 - 1;       % maximum integer value for the image

%% params Dai modal wavefront estimation
shstruct.sa_radius_m = shstruct.pitch/2;
shstruct.dai_n_zernike = 5;  % max radial order of the Zernike polynomials

%% replace your reference SHWFS images here
load sh_flat;    % (almost) diffraction-limited image taken with the SHWFS
load sh_flat_bg; % dark frame (optional)

%% run the calibration
shwfs_calibrate;
