% adbteo_04 [script]
clc, clear, close all
 
% Cria imagem sintética g
w = 256;
objt = 192; fundo = 64; rdn = 10;
g = makeImSynthHex(w,objt,fundo,rdn);
 
g = im2double(g);
Ph = fspecial('prewitt');
gPh = imfilter(g,Ph,'replicate','conv');
Pv = Ph';
gPv = imfilter(g,Pv,'replicate','conv');
Sh = fspecial('sobel');
gSh = imfilter(g,Sh,'replicate','conv');
Sv = Sh';
gSv = imfilter(g,Sv,'replicate','conv');
 
% Normaliza, pois existem
% valores negativos
gPh = mat2gray(gPh);
gPv = mat2gray(gPv);
gSh = mat2gray(gSh);
gSv = mat2gray(gSv);
 
% Display
figure, imshow(g)
title('Imagem de entrada')
figure, subplot(1,2,1), imshow(gPv)
title('Prewitt vertical')
subplot(1,2,2), imshow(gPh)
title('Prewitt horizontal')
figure, subplot(1,2,1), imshow(gSv),
title('Sobel vertical')
subplot(1,2,2), imshow(gSh)
title('Sobel horizontal')