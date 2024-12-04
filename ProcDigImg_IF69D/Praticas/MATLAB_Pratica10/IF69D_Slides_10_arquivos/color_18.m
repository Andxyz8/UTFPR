% color_18 [script]
% Segmentação por limiarização utilizando diferentes limiares para os canais de cores
% ao comparar a cor de referência com as cores de todos os pixels da imagem.
% Faz com dois color spaces: 1) HSV, 2) L*a*b*. O resultado com L*a*b* é melhor.

clc, clear, close all

rgb = imread('hotwheels09m.png');
figure, imshow(rgb), title('Imagem de entrada')

% Color space 1) HSV, vamos usar apenas a cromaticidade (V é o componente acromático)
hsv = rgb2hsv(rgb);
h = hsv(:,:,1); s = hsv(:,:,2);
% % É possível inspecionar os valores de H e S da região do color_17.m
% hsv_crop = hsv(155:169,155:169,:);
% h_crop = hsv_crop(:,:,1);
% s_crop = hsv_crop(:,:,2);
% Limiares para H e S
hL = (h > 0.96) | (h < 0.04); % Hue do vermelho
sL = (s > 0.7);               % Saturação alta
Rhs = hL & sL;
% Mostra em uma tiledlayout
figure, t = tiledlayout(1,3); t.TileSpacing = 'tight';
nexttile, imshow(hL), title('i1: Limiarização de H')
nexttile, imshow(sL), title('i2: Limiarização de S')
nexttile, imshow(Rhs); title('Segmentação (i1 & i2)')

% Color space 2) L*a*b*, vamos usar apenas a cromaticidade (L* é o componente acromático)
lab = rgb2lab(rgb);
a = lab(:,:,2); b = lab(:,:,3);
% Limiares para a* e b*
aL = (a > 24) & (a < 104); % média interquartil do a* em color_17.m = 64
bL = (b > 8) & (b < 88);   % média interquartil do b* em color_17.m = 48
Rab = aL & bL;
% Mostra em uma tiledlayout
figure, t = tiledlayout(1,3); t.TileSpacing = 'tight';
nexttile, imshow(aL), title('i1: Limiarização de a*')
nexttile, imshow(bL), title('i2: Limiarização de b*')
nexttile, imshow(Rab); title('Segmentação (i1 & i2)')