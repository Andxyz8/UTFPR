% fft_PbPaIdeal [script]

clear all, close all,  clc
 
f = imread('cameraman.tif');
fd = double(f);
 
% DFT 2D
F = fft2(fd);
% Reposicionamento (shifiting)
F = fftshift(F);
 
% Filtro passa-baixas ideal
[nr nc] = size(f);
rc = round(nr/2);
cc = round(nc/2);
bw = false(nr,nc);
bw(rc,cc) = 1;
d = bwdist(bw);
raio = 30;
Hpb = double(d < raio);
% Filtro passa-altas ideal
Hpa = 1 - Hpb;
 
% Multiplicação ponto-a-ponto
Gpb = F .* Hpb;
Gpa = F .* Hpa;
 
% DFT 2D inversa
gpb = ifft2(Gpb);
gpa = ifft2(Gpa);
% Magnitude e visualização
gpb = mat2gray(abs(gpb));
gpa = mat2gray(abs(gpa)); 
 
% Display
figure, imshow(f)
title('Imagem de entrada')
figure,
imshow(mat2gray(log(1+abs(F))))
title('DFT da imagem')
figure, imshow(mat2gray(Hpb))
title('Filtro PB ideal')
figure, imshow(mat2gray(Hpa))
title('Filtro PA ideal')
figure, imshow(gpb)
title('Saída PB')
figure, imshow(gpa)
title('Saída PA')
