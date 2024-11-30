% a04_04 [script]
clc, clear, close all

g1 = imread('b5s.40.bmp');
g2 = imread('b5s.100.bmp');

hm5 = fspecial('average', [5 5]); %média 5x5
hg5 = fspecial('gaussian', [5 5], 1); %gaussiano 5x5 sigma=1

g1hm5 = imfilter(g1, hm5);
g1hg5 = imfilter(g1, hg5);
g2hm5 = imfilter(g2, hm5);
g2hg5 = imfilter(g2, hg5);

figure
subplot(1,3,1), imshow(g1), title('original')
subplot(1,3,2), imshow(g1hm5), title('média 5x5')
subplot(1,3,3), imshow(g1hg5), title('gaussiano 5x5 sigma=1')
figure
subplot(1,3,1), imshow(g2), title('original')
subplot(1,3,2), imshow(g2hm5), title('média 5x5')
subplot(1,3,3), imshow(g2hg5), title('gaussiano 5x5 sigma=1')