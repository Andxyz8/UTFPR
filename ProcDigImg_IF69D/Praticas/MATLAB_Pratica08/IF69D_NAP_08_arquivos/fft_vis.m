% fft_vis [script]

clc, clear, close all

g = imread('cameraman.tif');
gd = double(g);

% DFT 2D
dft = fft2(gd);
% Reposicionamento (shifiting)
dfts = fftshift(dft);
% Magnitude
dftsm = abs(dfts);
% Visualização
dftsmv = mat2gray(log(1+dftsm));

%Display
figure
imshow(g)
title('Imagem de entrada')
figure
imshow(dftsmv)
title('DFT 2D')