% mse_iqm [script]
% Imagem boat.512.tiff disponível em http://sipi.usc.edu/database/

clear all; close all; clc

gorig = imread('boat.512.tiff');
figure, imshow(gorig), title('Original')

% Insere ruido Gaussiano m = 0 e desvio padrão
g1 = imnoise(gorig,'gaussian',(0/255),(5/255)^2);
g1 = imnoise(g1,'salt & pepper',0.02);
figure, imshow(g1), title('Com ruido 5')
g2 = imnoise(gorig,'gaussian',(0/255),(5/255)^2);
g2 = imnoise(g2,'salt & pepper',0.05);
figure, imshow(g2), title('Com ruido 10')

mse0 = immse(gorig, gorig) %MSE entre orig e orig
mse1 = immse(gorig, g1) %MSE entre orig e sd=5
mse1 = immse(gorig, g2) %MSE entre orig e sd=10

g1 = uint8(g1);
g2 = uint8(g2);
imwrite(g1, 'boatNoiseG05SP02.png');
imwrite(g2, 'boatNoiseG05SP05.png');