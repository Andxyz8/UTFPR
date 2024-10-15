% a02_pre_03_graysUint [script]

% Criar, mostrar e salvar uma imagem png de dimensão height = 50 pixels,
% contendo toda a escala de níveis de cinza de bit-depth 8 bits por pixel,
% em ordem crescente.
% Dica: usar o operador colon e a função repmat.

clc, clear, close all

v = 0:1:255;

v = uint8(v);
figure, imshow(v), title('v')

v2 = repmat(v, 50, 1);
figure, imshow(v2), title('v2')

imwrite(v2, 'graysUint8.png');