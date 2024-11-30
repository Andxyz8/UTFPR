% sharpening_unsharp [script]
clc, clear, close all
 
g = imread('flowervaseg.png');
g = double(g); %double, uint8(1)
%g = im2double(g);%im2double,im2uint8(2)
 
h = fspecial('gaussian', [5 5], 1);
gg = imfilter(g, h, 'replicate');
 
unshmask = g - gg;
gunsharp = g + unshmask;
gunsharp = uint8(gunsharp);%double,uint8(1)
%gunsharp = ...,
%im2uint8(gunsharp); %im2double,im2uint8(2)
 
%Display
figure, imshow(g,[])
title('Original')
figure, imshow(unshmask,[])
title('Imagem máscara unsharp')
figure, imshow(gunsharp)
title('Realce')