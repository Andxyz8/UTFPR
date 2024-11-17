% opening_bw36_steps [script]
clc, clear, close all
imtool close all
 
bw = imread('exMorph4.bmp');
se = strel('square', 3);
bw_e = imerode(bw, se);
bw_e_v = visualize(bw, bw_e);
bw_e_d = imdilate(bw_e, se);
bw_e_d_v = visualize(bw_e, bw_e_d);

figure
t = tiledlayout(5,1);
t.TileSpacing = 'tight'; t.Padding = 'compact';
nexttile
imshow(bw,'InitialMagnification','fit'), title('bw')
pixelgrid % zoom in to see the grid
nexttile
imshow(bw_e,'InitialMagnification','fit'), title('bw\_e')
pixelgrid % zoom in to see the grid
nexttile
imshow(bw_e_v,'InitialMagnification','fit'), title('bw\_e\_v')
pixelgrid % zoom in to see the grid
nexttile
imshow(bw_e_d,'InitialMagnification','fit'), title('bw\_e\_d')
pixelgrid % zoom in to see the grid
nexttile
imshow(bw_e_d_v,'InitialMagnification','fit'), title('bw\_e\_d\_v')
pixelgrid % zoom in to see the grid