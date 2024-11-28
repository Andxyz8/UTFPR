close all; clear all; clc;

img_original = imread('cameraman.tif');
img_original_d = double(img_original);

[tam_img_x, tam_img_y] = size(img_original);

% Gerar as coordenadas para o filtro
[coord_x, coord_y] = meshgrid(1:tam_img_y, 1:tam_img_x);
centro_x = tam_img_y / 2;
centro_y = tam_img_x / 2;
dist_x = coord_x - centro_x;
dist_y = coord_y - centro_y;
distancia = sqrt(dist_x.^2 + dist_y.^2);

sigma_passa_alta = 25;
sigma_passa_baixa = 25;

filtro_baixa = exp(-(distancia.^2) / (2 * sigma_passa_baixa^2));
filtro_baixa = mat2gray(filtro_baixa);

filtro_alta = 1 - exp(-(distancia.^2) / (2 * sigma_passa_alta^2));
filtro_alta = mat2gray(filtro_alta);

img_fft = fft2(img_original_d);
img_fft_s = fftshift(img_fft);

img_baixa_fft = img_fft_s .* filtro_baixa;
img_alta_fft = img_fft_s .* filtro_alta;

img_baixa = real(ifft2(ifftshift(img_baixa_fft)));
img_alta = real(ifft2(ifftshift(img_alta_fft)));


figure;

% Imagem original e seu espectro
subplot(3, 2, 1);
imshow(img_original, []);
title('Imagem original');

subplot(3, 2, 2);
img_fft_m = log(1 + abs(img_fft_s));
img_fft_m_v = mat2gray(img_fft_m);
imshow(img_fft_m_v, []);
title('Espectro original');

% Passa-baixas e resultado
subplot(3, 2, 3);
imshow(filtro_baixa, []);
title('Filtro passa-baixas');

subplot(3, 2, 4);
imshow(img_baixa, []);
title('Resultado passa-baixas');

% Passa-altas e resultado
subplot(3, 2, 5);
imshow(filtro_alta, []);
title('Filtro passa-altas');

subplot(3, 2, 6);
imshow(img_alta, []);
title('Resultado passa-altas');
