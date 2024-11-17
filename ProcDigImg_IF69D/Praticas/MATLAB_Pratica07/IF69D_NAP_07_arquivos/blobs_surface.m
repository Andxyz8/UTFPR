% blobs_surface [script]
clc, clear, close all

g = imread('whitecells4.png');
 
%Coord do canto sup esq da região
%imin = 30
%jmin = 110
%Coord do canto inf dir da região
%imax = 70
%jmax = 150
reg = g(30:70,110:150);
%Plano em 128, de mesmas dimensões da região
z = ones(41,41).*128;
 
%Display
figure, imshow(g)
figure, imshow(reg)
figure
surf(double(reg), 'FaceAlpha', 0.5)
zlim([0 255])
colormap('gray')
hold on
surf(z, 'EdgeColor', 'none')
hold off
