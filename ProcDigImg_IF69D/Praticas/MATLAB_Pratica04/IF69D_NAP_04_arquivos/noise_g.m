% apply_view_noise [script]
clc, clear, close all

g = imread('Lenna256g.png');

%m=0 e desvio padrão = 20
gg = imnoise(g,'gaussian',(0/255),(20/255)^2);

%Apenas ruído
s = imsubtract(double(g), double(gg));

%Para visualizar o ruído
sviz = uint8(s + 127);

%Display
figure, imshow(g),
title('Original')
figure, imshow(gg)
title('Ruído Gaussiano m=0 dp=20')
figure, imshow(sviz)
title('(Original)-(Com ruído)+127')
figure, imhist(sviz)
ylim('auto'), title('Histograma do ruído')

%Só conferindo o dp do ruído:
dp = std(double(s(:)))