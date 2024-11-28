% color_09 [script]

clc, clear, close all

% Equalização do histograma
% Converter de RGB para um espaço de cores que separe a informação
% de luminância da informação de cor (cromaticidade),
% realizar a operação apenas no canal de luminância e
% converter para RGB.
% Imagem: https://www2.eecs.berkeley.edu/Research/
% Projects/CS/vision/bsds/BSDS300/html/dataset/
% images/color/210088.html
rgb = imread('210088.jpg');
figure, imshow(rgb), title('rgb')

hsv = rgb2hsv(rgb);
v = hsv(:,:,3);
figure, imshow(v), title('v')
v_Eq = histeq(v,256);
figure, imshow(v_Eq), title('v\_Eq')

hsv_Eq = cat(3,hsv(:,:,1),hsv(:,:,2),v_Eq);
rgb_Eq = hsv2rgb(hsv_Eq);
figure, imshow(rgb_Eq), title('rgb\_Eq')

% imwrite(v, 'color_09_v.png');
% imwrite(v_Eq, 'color_09_v_Eq.png');
% imwrite(rgb_Eq, 'color_09_rgb_Eq.png');