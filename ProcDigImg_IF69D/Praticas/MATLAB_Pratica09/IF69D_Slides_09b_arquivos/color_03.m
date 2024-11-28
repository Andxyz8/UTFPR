% color_03 [script]

clc, clear, close all

m = ones(64).*255;
z = zeros(64);
r = cat(3,m,z,z); g = cat(3,z,m,z); b = cat(3,z,z,m);
rgb1 = uint8([r g b]); figure; imshow(rgb1);
gray1 = rgb2gray(rgb1); figure; imshow(gray1);

% Imagem: http://www.robots.ox.ac.uk/~vgg/data/
%         flowers/102/index.html
rgb2 = imread('image_03341.jpg'); figure, imshow(rgb2);
gray2 = rgb2gray(rgb2); figure; imshow(gray2);

% imwrite(rgb1, 'color_03_rgb1.png');
% imwrite(gray1, 'color_03_gray1.png');
% imwrite(gray2, 'color_03_gray2.png');