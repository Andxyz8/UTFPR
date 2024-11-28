% color_06 [script]

clc, clear, close all

% Suavização (filtro passa baixas)
% Fazer a operação no canais R, G, B, separadamente
% Imagem:
% https://raw.githubusercontent.com/clausmichele/
% CBSD68-dataset/master/CBSD68/noisy25/0037.png
rgb = imread('0037.png');
figure, imshow(rgb), title('rgb')

r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);
r_g_b = [r g b];
figure, imshow(r_g_b), title('r\_g\_b')

h = fspecial('gaussian', [5 5], 1);
rPB = imfilter(r, h);
gPB = imfilter(g, h);
bPB = imfilter(b, h);
r_g_b_PB = [rPB gPB bPB];
figure, imshow(r_g_b_PB), title('r\_g\_b\_PB')

rgbPB = cat(3, rPB, gPB, bPB);
figure, imshow(rgbPB), title('rgbPB')

% imwrite(r_g_b, 'color_06_r_g_b.png');
% imwrite(r_g_b_PB, 'color_06_r_g_b_PB.png');
% imwrite(rgbPB, 'color_06_rgbPB.png');