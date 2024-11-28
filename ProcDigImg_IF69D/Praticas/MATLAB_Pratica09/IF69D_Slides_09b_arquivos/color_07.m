% color_07 [script]

clc, clear, close all

% Realce (sharpening, filtro passa-altas)
% Fazer a operação nos canais R,G,B, separadamente
% Imagem: https://www2.eecs.berkeley.edu/Research/
% Projects/CS/vision/bsds/BSDS300/html/dataset/
% images/color/241004.html
rgb = imread('241004.jpg');
figure, imshow(rgb), title('rgb')
r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);
r_g_b = [r g b];
figure, imshow(r_g_b), title('r\_g\_b')

h = -fspecial('laplacian',0);
rPA = imfilter(double(r), h);
gPA = imfilter(double(g), h);
bPA = imfilter(double(b), h);
rS = uint8(double(r) + double(rPA));
gS = uint8(double(g) + double(gPA));
bS = uint8(double(b) + double(bPA));
r_g_b_S = [rS gS bS];
figure, imshow(r_g_b_S), title('r\_g\_b\_S')

rgb_S = cat(3, rS, gS, bS);
figure, imshow(rgb_S), title('rgb\_S')

% imwrite(r_g_b, 'color_07_r_g_b.png');
% imwrite(r_g_b_S, 'color_07_r_g_b_S.png');
% imwrite(rgb_S, 'color_07_rgb_S.png');