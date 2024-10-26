close all; clear all; clc;

% Função para plotar os gráficos 3D
function [] = plot_bar3d(titulo, matrix)
    figure;

    bar3(matrix);

    title(titulo);
    xlabel('Colunas');
    ylabel('Linhas');
    zlabel('Valores');
end

% ITEM a)

% Máscara de convolução do filtro de média 3x3 com fspecial
mask_box_filter_fspecial = fspecial('average', [3 3]);

% Usado para comparação
plot_bar3d('Máscara box filter 3x3 fspecial', mask_box_filter_fspecial);

% Máscara de convolução do filtro de média 3x3 definida na unha
mask_box_filter_unha = ones(3, 3) / 9;

plot_bar3d('Máscara box filter 3x3 na mão', mask_box_filter_unha);


% ITEM b)

% Máscara de convolução do filtro Gaussiano 5x5 com fspecial

mask_gaussian_filter_fspecial = fspecial("gaussian", [5, 5], 1);

% Usado para comparação
plot_bar3d( ...
    'Máscara Gaussian filter 5x5 fspecial', ...
    mask_gaussian_filter_fspecial ...
);

% Máscara de convolução do filtro Gaussiano 5x5 na mão

% Vars necessárias
sigma = 1;
tam_janela = 5;
pos_meio = (tam_janela + 1)/2;
mask = zeros(tam_janela, tam_janela);

% Loops para preencher a máscara
for i = 1:tam_janela
    x = i - pos_meio;

    for j = 1:tam_janela
        y = j - pos_meio;
        mask(i, j) = (1/(2 *pi*sigma^2))*exp(-(x^2 + y^2)/(2*sigma^2));
    end
end

% Normalização
mask_gaussian_filter_unha = mask/sum(mask(:));

plot_bar3d( ...
    'Máscara Gaussian filter 5x5 na unha', ...
    mask_gaussian_filter_unha ...
);
