close all; clear all; clc;

img_original = imread("AD21-0016-001_F3_P3_knife_plane_drop_v~small.jpg");

img_d = double(img_original(:, :, 1));

% Normalizar [0, 1]
img_norm = mat2gray(img_d);

% Inteiros para aplicar colormap
img_d = uint8(img_norm.*255);

img_pseudocolorida = colormap(jet(256));

subplot(1, 2, 1);
imshow(img_original);
title("Imagem original");

subplot(1, 2, 2);
imshow(img_d, img_pseudocolorida);
title("Imagem pseudocolorida");
