% blobs_th_global_auto [script]
clc, clear, close all
 
g = imread('whitecells4.png');
 
th = graythresh(g);
bw = im2bw(g, th);
 
% Nível de cinza do th na faixa [0 255]
thp = th*255;
 
%Display
figure, imshow(g)
figure, imshow(bw)
figure, imhist(g)
text(thp,400,['\downarrow',' Limiar Otsu = ',num2str(thp),...
    ' (' num2str(th,2) ')'])
