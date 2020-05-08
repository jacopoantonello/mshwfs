% Example about using the code for Zernike polynomials

clear;
clc;
close all;
%% add library
addpath('../mshwfs/');
%% use Zernike polynomials up to radial order 6
max_radial_order = 6;
zs = zernike_table(max_radial_order);
%% make a pupil space grid
dd = linspace(-1, 1, 200);
[xx, yy] =  meshgrid(dd, dd);
zs = zernike_cache(zs, xx, yy);
%% make a random aberration with a given root-mean-square value
rmsset = 1.2;
zc1 = randn(zs.ncoeff - 1, 1);
zc1 = rmsset*zc1/norm(zc1);
zc = [0; zc1]; % set piston value (mean value) to zero
clear zc1;

sfigure(1);
plot(1:zs.ncoeff, zc, 'Marker', '.');
xlabel('Noll index #');
ylabel('[rad]');
grid on;
%% evaluate the polynomials over a grid
wf1 = zernike_eval(zs, zc);

sfigure(2);
imagesc(dd, dd, wf1); axis image;
xlabel('[norm]');
ylabel('[norm]');
h = colorbar();
ylabel(h, '[rad]');
%% double check Noll normalisation
fprintf('rms analytical %d\n', norm(zc));
fprintf('rms numerical  %d\n', sigrms(wf1(:)));
%% fit a wavefront
zchat = zernike_fit(zs, wf1);
sfigure(3);
subplot(2, 1, 1);
plot(1:zs.ncoeff, zc, 'Marker', '.');
hold on;
plot(1:zs.ncoeff, zchat, 'Marker', '.');
legend('true', 'fit');
xlabel('Noll index #');
ylabel('[rad]');
grid on;
subplot(2, 1, 2);
plot(1:zs.ncoeff, abs(zc - zchat), 'Marker', '.');
legend('fit error');
xlabel('Noll index #');
ylabel('[rad]');
grid on;
%% rotate & flip the pupil
alpha = pi/6;
zcrot = zernike_rotmatrix(zs, alpha)*zc;
zxflip = zernike_flipxmatrix(zs)*zc;
zyflip = zernike_flipymatrix(zs)*zc;

sfigure(4);
subplot(2, 2, 1);
imagesc(dd, dd, zernike_eval(zs, zc)); axis image; axis off;
title('original');
subplot(2, 2, 2);
imagesc(dd, dd, zernike_eval(zs, zcrot)); axis image; axis off;
title('rotated');
subplot(2, 2, 3);
imagesc(dd, dd, zernike_eval(zs, zxflip)); axis image; axis off;
title('xflip');
subplot(2, 2, 4);
imagesc(dd, dd, zernike_eval(zs, zyflip)); axis image; axis off;
title('yflip');
