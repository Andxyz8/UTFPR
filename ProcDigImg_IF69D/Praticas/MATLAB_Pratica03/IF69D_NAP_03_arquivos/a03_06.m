% a03_06 [script]

clc, clear, close all

g1 = imread('gDSC04422m16.png');
figure
subplot(2,1,1), imshow(g1), title('gDSC04422m16')
subplot(2,1,2), imhist(g1), title('imhist axis tight')
axis tight % para não cortar y

g2 = imread('42049_20-200.png');
figure
imshow(g2), title('42049-20-200')
figure
imhist(g2), title('42049-20-200 imhist')
figure
imhist(g2), title('42049-20-200 imhist axis tight')
axis tight % para não cortar y

g3 = imread('vpfig.png');
figure
imshow(g3), title('vpfig')
figure
imhist(g3), title('vpfig imhist axis tight')
axis tight % para não cortar y

% Pode-se obter os valores do histograma 
[counts, binLocations] = imhist(g2);
figure
stem(binLocations,counts,'Marker','none'), title('usando stem');
axis tight
xlim([0 255])
npixels = numel(g2)
somah = sum(counts)