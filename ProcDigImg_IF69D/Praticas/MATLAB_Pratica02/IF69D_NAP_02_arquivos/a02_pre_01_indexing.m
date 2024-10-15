% a02_pre_01_indexing [script]

% Criar, mostrar e salvar uma imagem no formato png, contendo apenas o pássaro
% da imagem 42049.png. Também mostrar a 42049.png com um quadrado
% preto sobre a área que foi recortada. Dica: a primeira coisa a fazer é obter
% as coordenadas do canto superior direito e do cando inferior esquerdo do
% pássaro na imagem 42049.png.

clc, clear, close all

g = imread('42049.jpg');
figure
imshow(g)

%canto superior esquerdo: linha 10, coluna 50
%canto inferior direito: linha 30, coluna 300
crop = g(10:30,50:300);
figure
imshow(crop)

imwrite(crop, 'submatriz.png');

g2 = g;
g2(10:30,50:300) = 0;
figure
imshow(g2)