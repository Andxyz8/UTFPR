% a03_01_pre [script]
clc, clear, close all

g = checkerboard;
figure; imshow(g)

gu = im2uint8(g);
% Só pra lembrar:
% gu2 = uint8(g.*255); % igual im2uint8(g)
% igual = isequal(gu,gu2) % igual é '1'

% Função de transformação
y = uint8(0:1:255);
gIdx = double(gu)+1; % double(gu) pq 255+1...
% ...em um uint8 ocorre overflow (MATLAB não
% ..."gira" fazendo voltar pra 0; ele trunca em 255).
% +1 pq MATLAB é one-based indexing.

gtu = y(gIdx); % saída gtu é da mesma classe 
% da função de transformação y
figure; imshow(gtu);
% igual = isequal(gu,gtu) % igual é '1'