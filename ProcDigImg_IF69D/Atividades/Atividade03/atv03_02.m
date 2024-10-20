close all; clear all; clc;

imagem = imread('gDSC04422m16.png');

figure;
imshow(imagem);
title('Imagem original');


% 1
valores_histograma = imhist(imagem);

figure;
bar(valores_histograma)
title('Histograma original');


% 2
[N, M] = size(imagem);
valores_histograma_norm = valores_histograma/(N*M);

figure;
bar(valores_histograma_norm);
title('Histograma normalizado');


% 3
cdf = cumsum(valores_histograma_norm);

figure;
bar(cdf);
title('Soma cumulativa');


% 4
niveis_cinza_arredondado = cdf*255;
niveis_cinza_arredondado = uint8(niveis_cinza_arredondado);

figure;
bar(niveis_cinza_arredondado);
title('Niveis de cinza arredondados')


% 5
imagem_transformada = intlut(imagem, niveis_cinza_arredondado);

figure;
imshow(imagem_transformada);
title('Imagem transformada');
