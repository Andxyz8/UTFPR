close all; clear all; clc;

img = imread('flowervaseg.png');

OM = [0 -1 0; -1 5 -1; 0 -1 0];
LG = [-1 -1 -1; -1 9 -1; -1 -1 -1];

sharpened_OM = imfilter((img),OM, 'conv');
sharpened_LG = imfilter((img),LG, 'conv');

figure;
subplot(1,3,1), imshow(img, []), title('flowervaseg.png');
subplot(1,3,2), imshow(sharpened_OM, []), title('sharpened OM');
subplot(1,3,3), imshow(sharpened_LG, []), title('sharpened LG');