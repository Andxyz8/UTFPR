% color_14 [script]

clc, clear, close all

gray = imread('whitecells4.png');
grayd = mat2gray(gray); %double [0...1] 

% Inteiros para aplicar colormap
gray = uint8(grayd.*255); 
figure, imshow(gray), title('gray')
figure
c1 = colormap(jet(256));
imshow(gray, c1);
title('gray jet(256)')

% O Multilevel Th pode ser não-uniforme
% [0...0.75] -> 0
% (0.75..1]  -> 12 slices uniformes
% para detalhar as regiões de maior
% intensidade ('picos' das células)
slices = linspace(0.75,1,12); %[0...13]
gray13 = grayslice(grayd,slices);
figure
c2 = colormap(jet(13));
imshow(gray13, c2), colorbar()
title('gray13 não-uniforme jet(13)')

% imwrite(gray, 'color_14_gray.png');
% imwrite(gray, c1, 'color_14_c1.png');
% imwrite(gray13, c2, 'color_14_gray_c2.png');