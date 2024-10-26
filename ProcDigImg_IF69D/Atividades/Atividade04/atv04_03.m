close all; clear all; clc;

% Função para realizar a ordenação da janela mediana
function [vetor] = ordenar(vetor)
    % Janela fixa 3x3, portanto 9 posições
    for k = 1:8
        for l = k+1:9
            if vetor(k) > vetor(l)
                aux = vetor(k);
                vetor(k) = vetor(l);
                vetor(l) = aux;
            end
        end
    end
end

A = imread('salt-and-pepper1.tif');

figure;
imshow(A);
title('Imagem original');

B = A;

% Aplicando filtro da mediana com janela 3x3
for i = 2:size(A,1)-1
    for j = 2:size(A,2)-1
        % Atribui a janela 3x3 da mediana em um vetor para ordenação
        janela_plana = [A(i-1,j-1) A(i-1,j) A(i-1,j+1) A(i,j-1) A(i,j) A(i,j+1) A(i+1,j-1) A(i+1,j) A(i+1,j+1)];

        % Ordena o vetor para obter a mediana da janela 3x3
        vetor_ordenado = ordenar(janela_plana);

        % Atribui o valor do meio do vetor ordenado
        B(i,j) = vetor_ordenado(5);
    end
end

figure;
imshow(B);
title('Imagem filtrada com filtro da mediana 3x3');
