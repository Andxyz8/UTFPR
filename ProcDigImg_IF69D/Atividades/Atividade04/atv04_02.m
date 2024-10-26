close all; clear all; clc;

A = imread('b5s.40.bmp');

figure;
imshow(A);
title('Imagem original');

% Valores de sigma escolhidos
sigmaA = 1;
sigmaB = 5;

% Imagem filtrada com o primeiro valor de sigma
imgA_sigmaA = imgaussfilt(A, sigmaA);
figure; imshow(imgA_sigmaA);
title(['Imagem sigma = ', num2str(sigmaA)])

% Imagem filtrada com o segundo valor de sigma
imgA_sigmaB = imgaussfilt(A, sigmaB);
figure; imshow(imgA_sigmaB);
title(['Imagem sigma = ', num2str(sigmaB)]);
