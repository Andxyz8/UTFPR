close all; clear all; clc;

g = imread('sticknote_gray_01.png');
g = im2double(g);

Tlow1 = 0.1;
Thigh1 = 0.5;

Tlow2 = 0.2;
Thigh2 = 0.3;

edges1 = edge(g, 'Canny', [Tlow1 Thigh1]);
edges2 = edge(g, 'Canny', [Tlow2 Thigh2]);

figure, subplot(1,3,1), imshow(g)
title('Imagem de entrada');

subplot(1,3,2), imshow(edges1),
title('Combinacao 0.1 e 0.5');

subplot(1,3,3), imshow(edges2),
title('Combinacao 0.2 e 0.3');
