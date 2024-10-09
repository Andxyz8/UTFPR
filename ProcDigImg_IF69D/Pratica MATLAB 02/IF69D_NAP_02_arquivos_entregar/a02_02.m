%a02_02 [script]

clc, clear, close all

c1 = imread('cameraman.tif');
c2 = imread('cameraman2.tif');

figure
imshow(c1), title('c1')
figure
imshow(c2), title('c2')

%z = imsubtract(X,Y): Z = X-Y
%resultado negativos truncados pra zero
s1 = imsubtract(c1,c2);
figure
imshow(s1), title('s1 imsubtract(c1,c2)')
s1n = mat2gray(s1);
figure
imshow(s1n), title('s1n')

c1d = im2double(c1);
c2d = im2double(c2);
s2 = imsubtract(c1d,c2d);
figure
imshow(s2), title('s2 imsubtract(c1,c2)')
s2n = mat2gray(s2);
figure
imshow(s2n), title('s2n')

s3 = imabsdiff(c1,c2);
figure
imshow(s3), title('imabsdiff(c1,c2)')
s3n = mat2gray(s3);
figure
imshow(s3n), title('s3n')