%a02_03 [script]

clc, clear, close all

e1 = imread('earth1.tif');
e2 = imread('earth2.tif');

figure
imshow(e1), title('e1')
figure
imshow(e2), title('e2')

% Quero usar e2 para 'ponderar' e1
e1d = double(e1); % [0...255]
e2d = im2double(e2); % [0...1] sem ajuste de contraste 

e3d = immultiply(e1d,e2d);
e3d = uint8(e3d);
figure
imshow(e3d), title('e3d')