close all; clear all; clc;

img = imread('cameraman.tif');
img_d = double(img);

% DFT 2D com DFT 1D
dftr = fft(img_d, [], 1);
dft2d_1d = fft(dftr, [], 2);
dft2d_1d_s = fftshift(dft2d_1d);
dft2d_1d_m = log(1 + abs(dft2d_1d_s));
dft2d_1d_m_v = mat2gray(dft2d_1d_m);

% DFT com fft2
dft2d_fft2 = fft2(img_d);
dft2d_fft2_s = fftshift(dft2d_fft2);
dft2d_fft2_m = log(1 + abs(dft2d_fft2_s));
dft2d_fft2_m_v = mat2gray(dft2d_fft2_m);

figure;

% Exibe da DFT com separabilidade
subplot(1, 2, 1);
imshow(dft2d_1d_m_v);
title('DFT 2D (DFT 1D)');

% Exibe DFT com fft2
subplot(1, 2, 2);
imshow(dft2d_fft2_m_v);
title('DFT 2D (fft2)');
