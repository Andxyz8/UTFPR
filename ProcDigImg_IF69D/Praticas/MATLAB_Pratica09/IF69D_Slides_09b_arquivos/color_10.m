% color_10 [script]

clc, clear, close all

% Detecção de bordas:
% Método 1) Converter para grayscale e aplicar a detecção de bordas.
% Método 2) Aplicar o detector de bordas em R, G, B, individualmente
%           e depois combinar os três com uma operação OU lógica.
% Imagem: https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/
%         bsds/BSDS300/html/dataset/images/color/302003.html
rgb = imread('302003.jpg'); 
figure, imshow(rgb)
r = rgb(:,:,1); g = rgb(:,:,2); b = rgb(:,:,3);
r_g_b = [r g b];
figure, imshow(r_g_b), title('r\_g\_b')

% Método 1)
gray = rgb2gray(rgb);
figure, imshow(gray), title('gray')
gray_c = edge(gray, 'canny');
figure, imshow(gray_c), title('Canny em gray')

% Método 2)
r_c = edge(r, 'canny'); 
g_c = edge(g, 'canny'); 
b_c = edge(b, 'canny');
r_g_b_c = [r_c g_c b_c];
figure, imshow(r_g_b_c), title('Canny em R,G,B')
rgb_e = r_c | g_c | b_c;
figure, imshow(rgb_e), title('Canny em R,G,B -> OR')

% imwrite(r_g_b, 'color_10_r_g_b.png');
% imwrite(gray, 'color_10_gray.png');
% imwrite(gray_c, 'color_10_gray_c.png');
% imwrite(r_g_b_c, 'color_10_rgb_r_g_b_c.png');
% imwrite(rgb_e, 'color_10_rgb_e.png');