% adbteo_02 [script]
clc, clear, close all

g1 = ones(1,10)*64;
g2 = ones(1,10)*192;
g3 = linspace(192,64,10);
% Imagem sintética com bordas
% do tipo degrau e rampa
g = [g1 g2 g3 g1 fliplr(g3) g2 g1];
g = repmat(g,9,1);
ncol = size(g,2);
% Amostra linha da imagem
row = g(1,1:ncol);
% Máscara para derivada prim.
% por convolução para 
% reproduzir f(x+1)-f(x-1).
% Portanto, temos que fazer convolução
% com [1 0 -1] e não com [-1 0 1], como
% seria de se esperar. Isso porque a 
% convolução espelha a máscara em x e y.
h = [1 0 -1];
d = conv(row,h,'valid');
% Apenas para os graficos
% ficarem com o mesmo numero
% de pontos no eixo x:
d = [0 d 0];
%Display
figure, image(g)
colormap(gray(256));
title('Imagem');
axis off
axis image
figure
x = 1:ncol;
plot(x,row,'-ks','LineWidth',2)
grid
legend('Linha da imagem')
figure
plot(x,d,'-bd','LineWidth',2)
grid
legend('Derivada 1a usando conv')