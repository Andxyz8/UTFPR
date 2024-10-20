clc, clear, close all

imagem = imread('gDSC04422m16.png');

imshow(imagem);

%%1
valores_histograma = imhist(imagem);

%%2
[N, M] = size(imagem);
valores_histograma_norm = valores_histograma/(N*M);
bar(valores_histograma_norm);

%%3
cdf = cumsum(valores_histograma_norm);
bar(cdf);

%%4
niveis_cinza_arredondado = cdf*255;
niveis_cinza_arredondado = uint8(niveis_cinza_arredondado);
bar(niveis_cinza_arredondado);

%%5
imagem_transformada = intlut(imagem, niveis_cinza_arredondado);
imshow(imagem_transformada);
