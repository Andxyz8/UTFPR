% color_17 [script]
% Segmentação por limiarização utilizando a distância Euclidiana
% entre a cor de referência e as cores de todos os pixels da imagem. 
% Faz com dois color spaces: 1) RGB, 2) L*a*b*. O resultado com L*a*b* é melhor.

clc, clear, close all

img = imread('hotwheels09m.png');
figure, imshow(img), title('Imagem de entrada')
nr = size(img,1); nc = size(img,2);
% Talvez uma boa opção: pré-processar a imagem de entrada com uma
% suavização Gaussiana. Experimentar (descomentar linha abaixo) e comparar
% os resultados.
img = imgaussfilt(img, 0.5); % filtro Gaussiano sigma = 0.5 e janela 3x3
% Uma amostra do vermelho correspondente ao carrinho a ser segmentado
img_crop = img(155:169,155:169,:);
figure, imshow(img_crop, 'InitialMagnification', 'fit'), title('Amostra de 15x15 pixels')

% Color space 1) RGB
img_cs{1} = double(img);
% img_cs_sample{1} = img_cs{1}(155:169,155:169,:);
th{1} = 100; % testando para RGB: 100 ok. Critério: objeto o mais similar possível entre {1} e {2} sem exagerar nos falsos positivos
% Color space 2) L*a*b*
img_cs{2} = rgb2lab(img);
img_cs_sample{2} = img_cs{2}(155:169,155:169,:);
th{2} = 45; % testando para L*a*b*: 45 ok. Critério: objeto o mais similar possível entre {1} e {2} sem exagerar nos falsos positivos

for cs = 1:2
    % Color channel 1 da amostra
    img_cs_sample_ch1 = img_cs_sample{cs}(:,:,1);
    img_cs_sample_ch1_v = img_cs_sample_ch1(:);
    % Interquartile mean do channel 1 da amostra
    N = length(img_cs_sample_ch1_v); qL = round(N/4); qH = round(N/4*3);
    ch1_iqm = mean(img_cs_sample_ch1_v(qL:qH));
    % Color channel 2 da amostra
    img_cs_sample_ch2 = img_cs_sample{cs}(:,:,2);
    img_cs_sample_ch2_v = img_cs_sample_ch2(:);
    % Interquartile mean do channel 2 da amostra
    ch2_iqm = mean(img_cs_sample_ch2_v(qL:qH));
    % Color channel 3 da amostra
    img_cs_sample_ch3 = img_cs_sample{cs}(:,:,3);
    img_cs_sample_ch3_v = img_cs_sample_ch3(:);
    % Interquartile mean do channel 3 da amostra
    ch3_iqm = mean(img_cs_sample_ch3_v(qL:qH));

    img_iqm = [ch1_iqm ch2_iqm ch3_iqm];
    img_iqm = repmat(img_iqm, nr*nc, 1);
    img_cols = reshape(img_cs{cs}, nr*nc, 3);

    s = (img_iqm - img_cols).^2;
    D = sqrt(sum(s,2));

    Dm = reshape(D,nr,nc);
    R = Dm < th{cs};
    figure, imshow(R), title(['Segmentação usando dist Euclid no color space ' num2str(cs)])
end