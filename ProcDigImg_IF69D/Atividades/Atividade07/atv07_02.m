close all; clear all; clc;

% IMCOMPLETO: ESSA FOI A IDEIA INICIAL DE COMO
% ITERAR SOBRE AS IMAGENS, PRECISA FAZER A PARTE
% DA CATEGORIZAÇÃO DOS OBJETOS CONEXOS

lista_imagens = {
    "./L/L01.png", ...
    "./L/L02.png", ...
    "./L/L03.png", ...
    "./L/L04.png", ...
    "./L/L05.png", ...
    "./L/L06.png", ...
    "./L/L07.png", ...
    "./L/L08.png" ...
};

% Definição do elemento estruturante geral
se = strel('square', 4);

figure;

for i = 1:length(lista_imagens)
    img = imread(lista_imagens{i});

    a_open = imopen(img, se);
    a_open_closed = imclose(a_open, se);
    th = graythresh(a_open_closed);
    bw = im2bw(a_open_closed, th);

    subplot(2,4,i);

    title();

end
