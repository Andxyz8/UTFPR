% color_15 [script]
% Quantiza��o uniforme em 8, 27 e 64 cores de uma imagem sint�tica colorida
% contendo 32768 cores �nicas

clc, clear, close all

% allColors32 � uma imagem sint�tica true-color RGB (8 bits/pixel) com todas as cores
% poss�veis, como se estiv�ssemos usando 15 bits por pixel (5 para cada canal).
% N�mero de cores diferentes poss�veis: 2^15 = 32*32*32 = 32768.
% Observar que as dimens�es de allColors32 s�o 32*1024 = 32768.
rgb_integer = imread('allColors32.png');
% Inspecionando a imagem. Esperamos 32768 cores �nicas. J� que s�o 32 valores
% poss�veis para R dentro de um uint8, 32 para G dentro de um uint8,
% e 32 para B dentro de um uint8; R, G, e B podem assumir os seguintes
% valores: 0, 8, 16, 25, 33, ..., 247, 255 (cada step � a discretiza��o de 
% 255/32 = 7.96875)
[img_idx, img_cmap] = cmunique(rgb_integer);
rgb_integer_nuc = size(img_cmap, 1);
r_integer = rgb_integer(:,: ,1); % um dos canais
r_integer_unique = unique(r_integer);
r_integer_unique_table = array2table(r_integer_unique,... % transforma em uma table
    'VariableNames',{'Valores poss�veis de R, G, B'})     % para facilitar a visualiza��o

% Transforma r,g,b para faixa [0...1] classe double,
% para usar imquantizer depois
rgb = im2double(rgb_integer); 
figure, imshow(rgb), title('Imagem de entrada')

% Para confirmar n�mero de cores da imagem de entrada e obter o colormap
% da imagem que agora est� no range [0...1]
[x, map] = cmunique(rgb);
n_map = size(map, 1)

% Colorcloud na unha da imagem de entrada
figure, scatter3(map(:,1), map(:,2), map(:,3), 10, map, 'filled',...
    'MarkerEdgeColor','k')
title('Colorcloud da imagem de entrada')
xlim([0 1]), ylim([0 1]), zlim([0 1])
xlabel('R'), ylabel('G'), zlabel('B')

% Quantiza��o uniforme: o m�nimo poss�vel � quantizar cada canal em apenas
% dois valores. Isso d� 2*2*2 = 8 cores...
levels{1} = 1/2; % valor em que ocorre a quantiz. uniforme
% values{1} = [0 1]; % valor da cor resultante � 0 ou 1
values{1} = [1/4 3/4]; % valor da cor resultante � a do centro do cubo
% ...Pr�xima: 3*3*3 = 27...
levels{2} = [1/3 2/3]; % valores em que ocorre a quantiz. uniforme
values{2} = [1/6 3/6 5/6]; % valore da cor resultante � a do centro do cubo
% ...Pr�xima: 4*4*4 = 64
levels{3} = [1/4 2/4 3/4]; % valores em que ocorre a quantiz. uniforme
values{3} = [1/8 3/8 5/8 7/8]; % valor da cor resultante � a do centro do cubo

for n=1:3
    [r, g, b] = imsplit(rgb); % imsplit � outra maneira de separar os canais
    rq = imquantize(r, levels{n}, values{n});
    gq = imquantize(g, levels{n}, values{n});
    bq = imquantize(b, levels{n}, values{n});
    rgb_q = cat(3, rq, gq, bq);
    figure, imshow(rgb_q), title(['Quantiza��o uniforme ' num2str((n+1)^3) ' cores'])
    
    % Apenas para confirmar n�mero de cores da imagem de sa�da (quantizada)
    [x_q, map_q] = cmunique(rgb_q);
    n_map_q = size(map_q, 1)

    % Colorcloud na unha da imagem quantizada
    figure, scatter3(map_q(:,1), map_q(:,2), map_q(:,3), 300, map_q, 'filled',...
        'MarkerEdgeColor','k')
    title(['Colorcloud da imagem quantizada ' num2str((n+1)^3) ' cores'])
    xlim([0 1]), ylim([0 1]), zlim([0 1])
    xlabel('R'), ylabel('G'), zlabel('B')
end