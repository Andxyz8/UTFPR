%a02_04 [script]

clc, clear, close all

c = imread('contrast.jpg');
m = imread('mask.jpg');

figure
imshow(c), title('contrast')
figure
imshow(m), title('mask')

a = imabsdiff(c,m);
figure
imshow(a), title('a')
an = mat2gray(a);
figure
imshow(an), title('an')

a2 = imsubtract(double(c), double(m));
a2n = mat2gray(a2);
figure
imshow(a2n), title('a2n')