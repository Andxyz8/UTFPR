% otsu_rice [script]
clc, clear, close all
 
g = imread('rice.png');
figure, imshow(g);
 
t = graythresh(g);
bw = im2bw(g, t);
figure, imshow(bw)

% Observe que os grãos da parte
% inferior não são mantidos
% na imagem limiarizada