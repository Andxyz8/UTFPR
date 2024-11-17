% closing_bw36_steps [script]
clc, clear, close all
imtool close all
 
bw = imread('exMorph4.bmp');
se = strel('square', 3);
bw_d = imdilate(bw, se);
bw_d_v = visualize(bw, bw_d);
bw_d_e = imerode(bw_d, se);
bw_d_e_v = visualize(bw_d, bw_d_e);

figure
t = tiledlayout(5,1);
t.TileSpacing = 'tight'; t.Padding = 'compact';
nexttile
imshow(bw,'InitialMagnification','fit'), title('bw')
pixelgrid % zoom in to see the grid
nexttile
imshow(bw_d,'InitialMagnification','fit'), title('bw\_d')
pixelgrid % zoom in to see the grid
nexttile
imshow(bw_d_v,'InitialMagnification','fit'), title('bw\_d\_v')
pixelgrid % zoom in to see the grid
nexttile
imshow(bw_d_e,'InitialMagnification','fit'), title('bw\_d\_e')
pixelgrid % zoom in to see the grid
nexttile
imshow(bw_d_e_v,'InitialMagnification','fit'), title('bw\_d\_e\_v')
pixelgrid % zoom in to see the grid