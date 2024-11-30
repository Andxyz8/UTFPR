% a04_08 [script]

clear all, close all

g = imread('flowervaseg.png');
figure, imshow(g), title('original')

g = double(g);

h = fspecial('gaussian', [5 5], 1);
gg1 = imfilter(g, h, 'replicate');
unshmask1 = g - gg1;
gunsharp1 = g + unshmask1;
gunsharp1 = uint8(gunsharp1);
figure, imshow(gunsharp1), title('unsharp sharpening gaussian 5x5')

h = fspecial('average', [5 5]);
gg2 = imfilter(g, h, 'replicate');
unshmask2 = g - gg2;
gunsharp2 = g + unshmask2;
gunsharp2 = uint8(gunsharp2);
figure, imshow(gunsharp2), title('unsharp sharpening box 5x5')
