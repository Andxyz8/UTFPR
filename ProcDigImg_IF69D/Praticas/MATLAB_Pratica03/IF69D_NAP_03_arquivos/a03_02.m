% a03_02 [script]
clc, clear, close all

% g = imread('grays8bit.png'); %pra testar (fácil de inspecionar os valores)
g = imread('5.1.09.tiff');
figure; imshow(g)

% Função de transformação
y = uint8(255:-1:0);
figure, plot(y), xlim([0 255]), ylim([0 255])
% Usando intlut
gt = intlut(g,y);
figure, imshow(gt)