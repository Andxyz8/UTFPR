% adbteo_08 [script]
clc, clear, close all
 
g1 = ones(1,10)*64;
g2 = ones(1,10)*192;
g3 = linspace(192,64,10);
% Imagem sintética com bordas
% do tipo degrau e rampa
g = [g1 g2 g3 g1,...
     fliplr(g3) g2 g1];
g = repmat(g,9,1);
ncol = size(g,2);
% Amostra linha da imagem
row = g(1,1:ncol); 
% Aloca derivada prim.
d = zeros(1,ncol);
% Aloca derivada seg.
dd = zeros(1,ncol);
 
% Derivada de primeira ordem
% segundo definição
for k = 2 : ncol-1
    d(k) = row(k+1) - row(k-1);
end
d = d/2;
% Derivada de segunda ordem
for k = 2 : ncol-1
    dd(k) = d(k+1) - d(k-1);
end
dd = dd/2;
%Display
figure, image(g)
colormap(gray(256));
title('Imagem');
axis off
% Relação de aspecto para
% mostrar pixels quadrados
axis image
figure
x = 1:ncol;
plot(x,row,'-ks','LineWidth',2)
grid
legend('Linha da imagem')
figure
plot(x,d,'-bd','LineWidth',2)
grid
legend('Derivada 1a')
figure
plot(x,dd,'-ro','LineWidth',2)
grid
legend('Derivada 2a')