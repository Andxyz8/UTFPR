close all; clear all; clc;

img_original = imread('greens.jpg');

% Separa canais de cor
canal_r = double(img_original(:, :, 1)); % R
canal_g = double(img_original(:, :, 2)); % G
canal_b = double(img_original(:, :, 3)); % B

% Operação entre os canais R e G
img_dif_rg = canal_r - canal_g;

% Diferença de R e G em níveis de cinza
img_diff_cinza = mat2gray(img_dif_rg);

limiar = 0.45;
% limiar = graythresh(img_diff_cinza);

% Imagem binária
img_binaria = img_diff_cinza > limiar;

figure;

subplot(2, 2, 1);
imshow(img_original);
title("Original");

subplot(2, 2, 2);
imshow(img_diff_cinza, []);
title("R - G (cinza)");

subplot(2, 2, 3);
imshow(img_binaria);
title("Imagem binária");

subplot(2, 2, 4);
imshowpair(img_original, img_binaria, "blend");
title("Sobreposição");
