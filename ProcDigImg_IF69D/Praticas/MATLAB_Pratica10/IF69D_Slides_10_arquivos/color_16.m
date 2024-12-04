% color_16 [script]
% Quantização uniforme em 8 e 27 cores de uma imagem colorida.
% Em shark1.jpg com 8 cores observar que a barriga do tubarão foi pro
% grupo de cores da água. O que fazer pra tentar concertar usando
% quantização uniforme? R: aumentar o número de cores quantizadas. A
% próxima quantização uniforme possível é a de 27 cores (cada canal
% quantizado em três valores, então, 3*3*3 = 27 cores)

clc, clear, close all

rgb = imread('shark1.jpg');
rgb = im2double(rgb); % canais r,g,b na faixa [0...1] classe double

% Para obter número de cores da imagem de entrada e o colormap
[x1, map] = cmunique(rgb);
n_map = size(map, 1); % número de cores únicas da imagem original
figure, imshow(rgb), title(['Imagem de entrada ' num2str(n_map) ' cores'])

% Colorcloud na unha da imagem de entrada
figure, scatter3(map(:,1), map(:,2), map(:,3), 10, map, 'filled',...
    'MarkerEdgeColor','k')
title(['Colorcloud da imagem de entrada ' num2str(n_map) ' cores'])
xlim([0 1]), ylim([0 1]), zlim([0 1])
xlabel('R'), ylabel('G'), zlabel('B')

% Quantização uniforme: o mínimo possível é quantizar cada canal em apenas
% dois valores. Isso dá 2*2*2 = 8...
levels{1} = 1/2; % valor em que ocorre a quantiz. uniformes
values{1} = [1/4 3/4]; % cor resultante é a do centro do cubo quantizado
% ...Próxima: 3*3*3 = 27...
levels{2} = [1/3 2/3]; % valores em que ocorre a quantiz. uniforme
values{2} = [1/6 3/6 5/6]; % cor resultante é a do centro do cubo quantizado

for n=1:2
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    rq = imquantize(r, levels{n}, values{n});
    gq = imquantize(g, levels{n}, values{n});
    bq = imquantize(b, levels{n}, values{n});
    rgb_q = cat(3, rq, gq, bq);
    
    % Para obter número de cores da imagem de saída (quantizada) e o colormap
    [x_q, map_q] = cmunique(rgb_q);
    n_map_q = size(map_q, 1);

    % Mostra em uma tiledlayout
    figure, t = tiledlayout(2,2);
    t.TileSpacing = 'tight'; t.Padding = 'tight';
    nexttile, imshow(rgb_q), title(['Quant unif ' num2str((n+1)^3) ' cores (' num2str(n_map_q) ' cores resultantes)'])
    % Colorcloud na unha da imagem quantizada
    nexttile, scatter3(map_q(:,1), map_q(:,2), map_q(:,3), 200, map_q, 'filled',...
        'MarkerEdgeColor','k')
    title('Colorcloud')
    xlim([0 1]), ylim([0 1]), zlim([0 1])
    xlabel('R'), ylabel('G'), zlabel('B')

    % Os mapa de cores dado por 'values' podem levar a uma interpretação errada do que é
    % segmentação. Por isso vamos mostrar também apenas as regiões disjuntas em grayscale
    % e com pseudocores, sem levar em consideração a nova cor para qual cada pixel foi remapeado.
    % Em redução de cores (quantização) pra visualização, codificação e feature
    % extraction isso seria importante. Mas pra segmentação não necessariamente, pois estamos
    % interessados em obter regiões, isto é, desde que a região tenha sido separada, a cor original
    % dessa região é menos importante pra nós.
    nexttile, imshow(x_q,[]), title('Visualizando em gray')
    nexttile, imshow(label2rgb(x_q)); title('Visualizando com pseudocores')
end

%allColors32: como tem todas as cores, a quantizada tem todas as quantizadas possíveis.
%shark1: como não tem todas as cores, a quantizada não tem todas as quantizadas possíveis.
% Curiosidade: uma das cores da quantização uniforme 8 cores foi atribuída
% a apenas dois pixels da imagem de entrada: (X,Y)=(277,127) e (X,Y)=(309,127) 