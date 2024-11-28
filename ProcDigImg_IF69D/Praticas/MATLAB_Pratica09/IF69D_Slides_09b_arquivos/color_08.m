% color_08 [script]

clc, clear, close all

% Equalização do histograma
% Converter de RGB para um espaço de cores que separe a informação
% de luminância da informação de cor (cromaticidade),
% realizar a operação apenas no canal de luminância e
% converter para RGB.
% Espaço de cores YIQ, Y é a luminância
% |Y| |0,299  0,587  0,114| |R|
% |I|=|0,596 -0.274 -0,322|.|G|
% |Q| |0.211 -0,523  0,312| |B|
% No MATLAB: YIQ=rgb2ntsc(RGB), RGB=ntsc2rgb(YIQ)
% Imagem: https://www2.eecs.berkeley.edu/Research/
% Projects/CS/vision/bsds/BSDS300/html/dataset/
% images/color/210088.html
rgb = imread('210088.jpg');
figure, imshow(rgb), title('rgb')

yiq = rgb2ntsc(rgb);
y = yiq(:,:,1);
figure, imshow(y), title('y')
y_Eq = histeq(y,256);
figure, imshow(y_Eq), title('y\_Eq')

yiq_Eq = cat(3,y_Eq,yiq(:,:,2),yiq(:,:,3));
rgb_Eq = ntsc2rgb(yiq_Eq);
figure, imshow(rgb_Eq); title('rgb\_Eq')

% imwrite(y, 'color_08_y.png');
% imwrite(y_Eq, 'color_08_y_Eq.png');
% imwrite(rgb_Eq, 'color_08_rgb_Eq.png');