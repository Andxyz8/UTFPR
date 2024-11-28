% color_04 [script]

clc, clear, close all

% Cores primárias e secundárias
%    S  R  Y  G  C  B  M  W
R = [0  1  1  0  0  0  1  1];  
G = [0  0  1  1  1  0  0  1];
B = [0  0  0  0  1  1  1  1];

RGB = cat(3, R, G, B);
figure, image(RGB);
set(gcf,'color',[0.5 0.5 0.5]);
HSV = rgb2hsv(RGB);

% H [0...360], S e V [0...100] 
Hc = HSV(:,:,1).*360;
Sc = HSV(:,:,2).*100;
Vc = HSV(:,:,3).*100;

