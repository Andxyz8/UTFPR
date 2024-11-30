% noise_sp
clc, clear, close all

g = imread('Lenna256g.png');

% Parâmetro:densidade de pixels com ruído
gsp = imnoise(g, 'salt & pepper', 0.05);

% Apenas ruído, só pra visualizar
z = uint8(zeros(size(g))+127);
sp = imnoise(z, 'salt & pepper', 0.05);
unique(sp) %para notar que sal=255,pim=0

%Display
figure
subplot(2,2,1)
imshow(g), title('Original')
subplot(2,2,2)
imshow(gsp)
title('Ruído sal-e-pimenta d=5%')
subplot(2,2,3)
imshow(sp)
title('Apenas ruído com d=5%')
subplot(2,2,4)
imhist(sp), ylim([0 numel(sp)*0.05])
title('Histograma do ruído')
