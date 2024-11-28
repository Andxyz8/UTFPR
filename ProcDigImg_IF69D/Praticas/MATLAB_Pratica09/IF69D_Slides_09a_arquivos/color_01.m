% color_01 [script]

clear, clc, close all
% Imagem:
% http://www.vision.caltech.edu/
%         visipedia/CUB-200.html
rgb = imread...
('Blue_Jay_0011_2702981729.jpg');
figure, imshow(rgb)

r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);

figure, imshow(r)
title('Matriz R')
figure, imshow(g)
title('Matriz G')
figure, imshow(b)
title('Matriz B')