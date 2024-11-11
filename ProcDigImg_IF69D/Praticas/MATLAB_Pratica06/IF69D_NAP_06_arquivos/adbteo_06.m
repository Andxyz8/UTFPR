% adbteo_06 [script]
clc, clear, close all
 
% Cria imagem sint�tica g
a = triu(ones(8,8))*64;
b = tril(ones(8,8),-1)*192;
g8 = fliplr(uint8(a+b));
 
g = im2double(g8);
Sh = fspecial('sobel');
gSh = imfilter(g,Sh,'replicate','conv');
Sv = Sh';
gSv = imfilter(g,Sv,'replicate','conv');
 
% Orienta��o do gradiente em graus.
% gSh cont�m as varia��es ao longo
% da dire��o vertical, isto �, ao longo
% do eixo y.
% gSv cont�m as varia��es ao longo
% da dire��o horizontal, isto �, ao longo
% do eixo x.
St = atand(gSh./gSv);
 
% Display
figure, image(g8)
colormap(gray(256));
title('Imagem de entrada');
axis image