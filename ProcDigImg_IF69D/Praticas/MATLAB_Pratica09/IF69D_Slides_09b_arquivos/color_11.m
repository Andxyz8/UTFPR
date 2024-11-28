% color_11 [script]

clc, clear, close all

% Pseudolorização e Indexed image
% Todos os níveis de cinza em
% uma imagem 50-by-256
gray = uint8(0:255);
gray = repmat(gray, 50, 1);
figure, imshow(gray), title('gray')
% https://www.mathworks.com/help/
% matlab/ref/colormap.html
% traversing B, C, G, Y, R
figure
c1 = colormap(jet(256));
imshow(gray, c1), title('colormap c1')
% traversing K to light copper
figure
c2 = colormap(copper(256));
imshow(gray, c2), title('colormap c2')
% traversing magenta to yellow
figure
c3 = colormap(spring(256));
imshow(gray, c3), title('colormap c3')
% cyclic 4-color map of
% red, white, blue, black
figure
c4 = colormap(flag(256));
imshow(gray, c4), title('colormap c4')
%Para salavar a imagem:
%imwrite(gray, c1, 'gray_jet.png');

% imwrite(gray,'color_11_gray.png');
% imwrite(gray,c1,'color_11_c1.png');
% imwrite(gray,c2,'color_11_c2.png');
% imwrite(gray,c3,'color_11_c3.png');
% imwrite(gray,c4,'color_11_c4.png');