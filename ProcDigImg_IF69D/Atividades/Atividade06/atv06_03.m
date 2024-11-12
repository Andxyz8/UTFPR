close all; clear all; clc;

g = imread('sticknote_gray_01.png');
g = im2double(g);

Tlow = 0.1;
Thigh = 0.8;

BW = edge(g,'Canny', [Tlow Thigh], 2);
[H,theta,rho] = hough(BW);

P = houghpeaks(H,4,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);

figure, imshow(g), hold on
max_len = 0;

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
