% adbteo_07 [script]
clc, clear, close all
 
% Cria imagem sintética g
w = 256;
objt = 192; fundo = 64; rdn = 10;
g = makeImSynthHex(w,objt,fundo,rdn);
 
g = im2double(g);
Sh = fspecial('sobel');
gSh = imfilter(g,Sh,'replicate','conv');
Sv = Sh';
gSv = imfilter(g,Sv,'replicate','conv');
 
% Imagem de magnitude do gradiente
S = sqrt(gSv.^2 + gSh.^2);
% Normaliza
gSh = mat2gray(gSh);
gSv = mat2gray(gSv);
S = mat2gray(S);
% Limiariza
Sbw = im2bw(S,graythresh(S));
 
% Display
figure, imshow(g)
title('Imagem de entrada')
figure, imshow(S),
title('Magn. do grad.')
figure, imshow(Sbw)
title('Magn. do grad. bw')