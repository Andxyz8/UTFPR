% color_12 [script]

clc, clear, close all

% Todos os níveis de cinza em
% uma imagem 50-by-256
gray = uint8(0:255);
gray = repmat(gray, 50, 1);
figure 
mesh(double(gray),'EdgeColor','black');
title('gray')
figure, imshow(gray), title('gray')
% spring: traversing magenta to yellow
figure
c1 = colormap(spring(256));
imshow(gray, c1)
title('Colormap spring 256 cores')
% Multilevel thresholding
% (quantização uniforme)
% [0...64] -> 0, [65...128] -> 1,
% [129...191] -> 2, [192...255] -> 3
gray4mth = grayslice(gray, 4);
figure
mesh(double(gray4mth),'EdgeColor','black');
title('Multilevel Th uniforme, 4 níveis')
figure
c2 = colormap(spring(4));
imshow(gray4mth, c2)
title('Colormap spring 4 cores')

% imwrite(gray,'color_12_gray.png');
% imwrite(gray,c1,'color_12_c1.png');
% imwrite(gray4mth,c2,'color_12_gray4mth_c2.png');