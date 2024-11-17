% closing_bw36 [script]
clc, clear, close all
imtool close all
 
bw = imread('exMorph4.bmp');
se = strel('square', 3);
c = imclose(bw, se);
cv = visualize(bw, c);

figure
t = tiledlayout(3,1);
t.TileSpacing = 'tight'; t.Padding = 'compact';
nexttile
imshow(bw,'InitialMagnification','fit'), title('bw')
nexttile
imshow(c,'InitialMagnification','fit'), title('c')
nexttile
imshow(cv,'InitialMagnification','fit'), title('cv')