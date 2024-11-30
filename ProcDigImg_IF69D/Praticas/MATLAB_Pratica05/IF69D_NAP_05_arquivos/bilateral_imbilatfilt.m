% bilateral_imbilatfilt_apply [script]
% ver https://www.mathworks.com/help/images/ref/imbilatfilt.html
% Teoria: Richard Szeliski, Computer Vision: Algorithms and
% Applications, 2nd Ed., 2021, Section 3.3.2, pp. 233, disponível em
% https://szeliski.org/Book

clc, clear, close all

img = imread('cameraman.tif');

% Insere ruido Gaussiano m = 0 e desvio padrão = 10
img_n = imnoise(img,'gaussian',(0/255),(10/255)^2);

% Apenas para comparar filtro da média
box_3 = fspecial("average", 3);
img_n_box = imfilter(img_n,box_3);

% Patch da imagem de coordenadas e tamanho [xmin ymin width height].
% xmin e ymin são coluna e linha do canto superior esquerdo
patch = imcrop(img_n,[170 35 50 50]);
patchVar = std2(patch)^2;
DoS = 2*patchVar;
img_n_b = imbilatfilt(img_n,DoS);

montage({img, img_n, img_n_box, img_n_b})

figure
t  = tiledlayout(2,2);
t.TileSpacing = 'tight'; t.Padding = 'tight';
nexttile
imshow(img), title('Original')
nexttile
imshow(img_n), title("Original + ruído")
nexttile
imshow(img_n_box), title("Saída do filtro da média")
nexttile
imshow(img_n_b), title("Saída do filtro bilateral")