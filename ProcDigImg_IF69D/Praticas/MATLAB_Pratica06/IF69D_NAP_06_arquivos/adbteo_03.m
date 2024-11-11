% adbteo_03 [script]
clc, clear, close all
 
% Cria imagem sint�tica g
w = 256;
objt = 192; fundo = 64; rnd = 10;
g = makeImSynthHex(w,objt,fundo,rnd);
 
g = im2double(g);
hv = [-1 0 1];
gv = imfilter(g, hv, 'replicate');%correlat.
hh = hv';
gh = imfilter(g, hh, 'replicate');%correlat.
 
% Normaliza, pois existem
% valores negativos
gv = mat2gray(gv);
gh = mat2gray(gh);
 
% Display
figure, imshow(g)
title('Imagem de entrada')
figure, imshow(gv)
title('Resultado da m�scara vertical')
figure, imshow(gh)
title('Resultado da m�scara horizontal')