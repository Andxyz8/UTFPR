% psnr_iqm [script]
% Imagem boat.512.tiff disponível em http://sipi.usc.edu/database/

clear all; close all; clc

gorig = imread('boat.512.tiff');
figure, imshow(gorig), title('Original')

g1 = imnoise(gorig,'gaussian',(0/255),(5/255)^2);
g1 = imnoise(g1,'salt & pepper',0.02);
figure, imshow(g1), title('Com ruido 5')
g2 = imnoise(gorig,'gaussian',(0/255),(5/255)^2);
g2 = imnoise(g2,'salt & pepper',0.05);
figure, imshow(g2), title('Com ruido 10')

psnr0 = psnr(gorig, gorig) %PSNR entre orig e orig
psnr1 = psnr(gorig, g1) %PSNR entre orig 
psnr2 = psnr(gorig, g2) %PSNR entre orig 