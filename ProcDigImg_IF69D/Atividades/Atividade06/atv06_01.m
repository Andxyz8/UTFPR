close all; clear all; clc;

g = imread('sticknote_gray_01.png');
g = im2double(g);

Sh = fspecial('sobel');
gSh = imfilter(g,Sh,'replicate','conv');
Sv = Sh';
gSv = imfilter(g,Sv,'replicate','conv');

S = sqrt(gSv.^2 + gSh.^2);
S_aprox = abs(gSv) + abs(gSh);

gSh = mat2gray(gSh);
gSv = mat2gray(gSv);
S = mat2gray(S);
S_aprox = mat2gray(S_aprox);

figure, subplot(2,2,1), imshow(g)
title('Imagem de entrada');

% subplot(3,2,3), imshow(gSv)
% title('Sobel vertical');

% subplot(3,2,4), imshow(gSh)
% title('Sobel horizontal');

subplot(2,2,3), imshow(S),
title('Magnitude do gradiente');

subplot(2,2,4), imshow(S_aprox),
title('Magnitude do gradiente aproximada');
