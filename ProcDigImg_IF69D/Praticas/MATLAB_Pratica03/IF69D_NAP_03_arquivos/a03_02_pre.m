% a03_02_pre [script]
clc, clear, close all

g = imread('5.1.09.tiff');
figure; imshow(g)

% Função de transformação
y = uint8(0:255);
figure, plot(y), xlim([0 255]), ylim([0 255])
% Usando intlut
gt = intlut(g,y);
figure, imshow(gt)

% Se verifica == 0, imagens iguais
verifica = double(g) - double(gt);
verifica = sum(verifica(:));