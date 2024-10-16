% a03_01 [script]
clc, clear, close all

% g = imread('grays8bit.png'); %pra testar (fácil de inspecionar os valores)
g = imread('xray01.png');
figure; imshow(g)

% Função de transformação
y = uint8(255:-1:0);
figure;
plot(y); xlim([0 255]); ylim([0 255]);
gIdx = double(g)+1; % double(gu) pq 255+1...
% ...em um uint8 ocorre overflow (MATLAB não
% ..."gira" fazendo voltar pra 0; ele trunca em 255).
% +1 pq MATLAB é one-based indexing.

gtu = y(gIdx); % saída gtu é da mesma classe 
% da função de transformação y
figure; imshow(gtu);