close all; clear all; clc;

lista_imagens = {
    "psl1_gray.png", ...
    "psl2_gray.png", ...
    "psl3_gray.png" ...
};

% Definição do elemento estruturante geral
se = strel('square', 5);

for i = 1:length(lista_imagens)
    img = imread(lista_imagens{i});

    figure, subplot(2,2,1), imshow(img)
    title("Entrada");

    % Realizando abertura
    a_open = imopen(img, se);

    subplot(2,2,2), imshow(a_open);
    title("Abertura");

    % Realizando fechamento
    a_open_closed = imclose(a_open, se);

    subplot(2,2,3), imshow(a_open_closed);
    title("Abertura + Fechamento");

    % Otsu
    th = graythresh(a_open_closed);

    % Binarização
    bw = ~imbinarize(a_open_closed, th);

    subplot(2,2,4), imshow(bw);
    title("Resultado");
end
