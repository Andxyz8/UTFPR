% opening_bw36 [script]
clc, clear, close all
imtool close all
 
bw = imread('exMorph4.bmp');
se = strel('square', 3);
o = imopen(bw, se);
ov = visualize(bw, o);

figure
t = tiledlayout(3,1);
t.TileSpacing = 'tight'; t.Padding = 'compact';
nexttile
imshow(bw,'InitialMagnification','fit'), title('bw')
nexttile
imshow(o,'InitialMagnification','fit'), title('o')
nexttile
imshow(ov,'InitialMagnification','fit'), title('ov')