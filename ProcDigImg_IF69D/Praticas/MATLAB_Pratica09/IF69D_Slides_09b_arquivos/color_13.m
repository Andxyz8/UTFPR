% color_13 [script]

clc, clear, close all

% Uma img=0 com dois pixels=1
g = zeros(200, 200);
g(50,150) = 1; g(150,50) = 1;
figure, imshow(g), title('g')
% Transformada da distância: para cada 
% pixel, calcula a dist Euclidiana até
% o pixel '1' mais próximo.
d = bwdist(g); dn = mat2gray(d);
figure, imshow(dn), title('dn')
dnn = 1 - dn;
figure, imshow(dnn); title('dnn')
% Para atenuar 10% uma das 'elevações'
t = tril(ones(200,200))*0.9;
t(~t) = 1; dnn = dnn.*t; 
gray = uint8(dnn.*255);
% Em gray, difícil de vizualizar as
% diferentes amplitudes entre os picos
figure, imshow(gray), title('gray')
% Pseudocoloring permite visualizar
figure
c1 = colormap(jet(256));
imshow(gray, c1)
title('gray jet(256)')
gray16 = grayslice(gray, 16);
figure
c2 = colormap(jet(16));
imshow(gray16, c2), colorbar()
title('gray16 jet(16)')

% imwrite(g, 'color_13_g.png');
% imwrite(dn, 'color_13_dn.png');
% imwrite(dnn, 'color_13_dnn.png');
% imwrite(gray, 'color_13_gray.png');
% imwrite(gray, c1, 'color_13_gray_c1.png');
% imwrite(gray16, c2, 'color_13_gray_c2.png');