% a04_02 [script]
clc, clear, close all

g1 = imread('b5s.40.bmp');
g2 = imread('b5s.100.bmp');

hm3 = fspecial('average', [3 3]); %média 3x3
g1hm3 = imfilter(g1, hm3);
g2hm3 = imfilter(g2, hm3);
hm5 = fspecial('average', [5 5]); %média 5x5
g1hm5 = imfilter(g1, hm5);
g2hm5 = imfilter(g2, hm5);
hm7 = fspecial('average', [5 5]); %média 5x5
g1hm7 = imfilter(g1, hm7);
g2hm7 = imfilter(g2, hm7);

figure
montage({g1,g1hm3,g1hm5,g1hm7})

figure
montage({g1,g2hm3,g2hm5,g2hm7})