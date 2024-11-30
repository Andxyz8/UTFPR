% a04_05 [script]
clc, clear, close all

g = imread('salt-and-pepper1.tif');

gmedian = medfilt2(g, [3 3]);

hm3 = fspecial('average', [3 3]); %média 3x3
ghm3 = imfilter(g, hm3);

hm5 = fspecial('average', [5 5]); %média 5x5
ghm5 = imfilter(g, hm5);

figure
subplot(2,2,1), imshow(g), title('original')
subplot(2,2,2), imshow(gmedian), title('mediana')
subplot(2,2,3), imshow(ghm3), title('média 3x3')
subplot(2,2,4), imshow(ghm5), title('média 5x5')