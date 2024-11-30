% a04_07 [script]

clear all, close all

g = imread('flowervaseg.png');
figure, imshow(g), title('original')

g = double(g);
h = fspecial('gaussian', [5 5], 1);
gg = imfilter(g, h, 'replicate');

unshmask = g - gg;
gunsharp = g + unshmask;
gunsharp = uint8(gunsharp);
figure, imshow(gunsharp), title('default unsharp sharpening')

amp = 3;
gunsharpc = g + amp*unshmask;
gunsharpc = uint8(gunsharpc);
figure, imshow(gunsharpc), title('intensified unsharp sharpening')