close all; clear all; clc;

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

% Foi usado o mesmo filtro do exercício 1 para obter o th e realizar a
% binarização da imagem

% Definição do elemento estruturante geral
se = strel('square', 5);

figure;

for i = 1:length(lista_imagens)
    img = imread(lista_imagens{i});

    a_open = imopen(img, se);
    a_open_closed = imclose(a_open, se);
    th = graythresh(a_open_closed);

    % Levou um tempo para perceber que a razão pela qual os valores,
    % obtidos na função regionprops, não fazerem tanto sentido era 
    % a falta dessa inversão (~) dos pixels na imagem binarizada
    % (fundo preto (0) e componentes conexos em branco (1))
    bw = ~im2bw(a_open_closed, th);

    stats = regionprops( ...
        bw, ...
        "Circularity", ...
        "Eccentricity", ...
        "Orientation", ...
        "EulerNumber", ...
        "Area", ...
        "BoundingBox", ...
        "Extent" ...
    );

    % Classificação baseada nas propriedades
    if isempty(stats)
        label = "L0" + i + ": Indeterminado";
        eccentricity = NaN;
        aspect_ratio = NaN;
        extent = NaN;
    else
        feature = stats(1);
        circularity = feature.Circularity;
        orientation = feature.Orientation;

        % Propriedade interessante (euler_number), retorna o número de 
        % objetos na imagem subtraído da quantidade de buracos no objeto.
        % Como temos apenas um objeto nas imagens, ficou tranquilo
        % deduzir o restante das propriedades para cada objeto.
        euler_number = feature.EulerNumber;

        eccentricity = feature.Eccentricity;
        bounding_box = feature.BoundingBox;
        extent = feature.Extent;

        % Regras classificação objetos
        if euler_number == 0 && eccentricity < 0.2
            label = "L0" + i +": Estrela";
        elseif euler_number < 0 && extent < 0.5
            label = "L0" + i +": Bispo";
        elseif euler_number > 0 && eccentricity > 0.5
            label = "L0" + i +": Retângulo";
        else
            label = "L0" + i +": Quadrado";
        end
    end

    % Exibir valores no console
    fprintf('Imagem %d: %s\n', i, lista_imagens{i});
    
    fprintf('   Circularity: %.4f\n', circularity);
    fprintf('   Orientation: %.4f\n', orientation);
    fprintf('   EulerNumber: %.4f\n', euler_number);
    fprintf('   Eccentricity: %.4f\n', eccentricity);
    fprintf('   Extent: %.4f\n', extent);
    fprintf('   Classificação: %s\n\n', label);

    % Coloca a imagem e a label no plot geral
    subplot(2, 4, i);
    imshow(bw);
    title(label);
end
