% blobs_th_global [script]
clc, clear, close all

g = imread('whitecells4.png');
 
% Usando operador relacional
% IMPORTANTE: bw1 é da classe logical
bw1 = g > 128;
 
% Usando a função im2bw
% O limiar deve ser um número entre 0 e 1
% IMPORTANTE: bw2, bw3 são da classe logical
% Limiar 128 (0.5)
bw2 = im2bw(g, 128/255);
% Limiar 115 (0.45)
bw3 = im2bw(g, 115/255);
 
% Display
figure, imshow(g)
title('g')
figure, imshow(bw1)
title('bw1, Limiar 128')
figure, imshow(bw2)
title('bw2, Limiar 128')
figure, imshow(bw3)
title('bw3, Limiar 115')
 
% A região do exemplo anterior
reg = g(30:70,110:150);
regbw = bw2(30:70,110:150);
% O plano de limiarização em 128
z = ones(41,41).*128;

% Display
% Mostra a imagem como uma superfície usando pseudocores
% para facilitar a visualização
figure
surf(double(reg), 'FaceAlpha', 0.7)
shading('interp')
zlim([0 255])
colormap('autumn')
hold on
% +regbw transforma de logical para double.
% Mostra os pixels '1' da imagem limiarizada com o valor 128,
% isto é, no mesmo nível do plano de corte que limiarizou a imagem.
surf((+regbw)*128,'FaceColor', [0.5 0.5 0.5])
% Mostra o plano de corte que limiarizou a imagem
surf(z, 'EdgeColor','none','FaceColor', [0.5 0.5 0.5],'FaceAlpha', 0.7)
hold off
