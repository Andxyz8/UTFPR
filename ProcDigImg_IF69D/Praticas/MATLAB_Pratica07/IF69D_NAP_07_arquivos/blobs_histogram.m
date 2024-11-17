% blobs_histogram [script]
clc, clear, close all
 
g = imread('whitecells4.png');
 
figure
subplot(2,1,1)
imshow(g)
subplot(2,1,2)
imhist(g)
text(55,1400,'\leftarrow fundo','HorizontalAlignment','left')
text(170,300,'\downarrow objeto','HorizontalAlignment','left')
