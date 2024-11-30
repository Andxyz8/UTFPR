% snrl_iqm [script]

clc, clear, close all

% SNRL = Ms/SDn
% Ms é a média do sinal, estimada considerando-se os pixels de uma região
% clara (sinal) e homogênea (sem bordas) da  imagem. SDn é o desvio padrão
% do ruído, estimado considerando-se os pixels de uma região escura
% (sem sinal, portanto, apenas ruído) e homogênea da imagem.
% Ref:  Wolfgang Birfellner, Applied Medical Image Processing: a Basic Course,
%       CRC Press, 2011.

g1 = imread('b1s.100.bmp');
g2 = imread('b5s.100.bmp');
g3 = imread('b9s.100.bmp');
figure
subplot(1,3,1), imshow(g1), title('g1')
subplot(1,3,2), imshow(g2), title('g2')
subplot(1,3,3), imshow(g3), title('g3')

% Interação para selecionar regiões na g1
disp('Selecione uma região para estimar a média do sinal.')
figure
[reg_s, rect_s] = imcrop(g1); % rect_s será parâmetro pra imcrop 
disp('Selecione uma região para estimar a variância do ruído.')
[reg_n, rect_n] = imcrop(g1); % rect_n será parâmetro pra imcrop 
SNRLg1 = mean(double(reg_s(:)))/std(double(reg_n(:)))

% Para g2 usa mesmas regiões
[reg_s] = imcrop(g2, rect_s);
[reg_n] = imcrop(g2, rect_n);
SNRLg2 = mean(double(reg_s(:)))/std(double(reg_n(:)))

% Para g3 usa mesmas regiões
[reg_s] = imcrop(g3, rect_s);
[reg_n] = imcrop(g3, rect_n);
SNRLg3 = mean(double(reg_s(:)))/std(double(reg_n(:)))