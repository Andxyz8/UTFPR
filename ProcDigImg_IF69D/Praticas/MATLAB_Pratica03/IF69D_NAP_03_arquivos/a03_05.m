% a03_05 [script]
clc, clear, close all

g = imread('radio.tif');
figure, imshow(g), title('original')

g = im2double(g); %imagem [0...1]
figure, imshow(g), title('im2double')
mi = min(g(:))
Ma = max(g(:))

gac = mat2gray(g); %autocontraste (normalização)
figure, imshow(gac), title('mat2gray')
mi = min(gac(:))
Ma = max(gac(:))

g1 = imadjust(g,[],[],0.4);
figure, imshow(g1), title('gamma 0.4')
m = min(g1(:))
M = max(g1(:))

g2 = imadjust(g,[],[],0.1);
figure, imshow(g2), title('gamma 0.1')
m = min(g2(:))
M = max(g2(:))

g3 = imadjust(g,[],[],2);
figure, imshow(g3), title('gamma 2')
m = min(g3(:))
M = max(g3(:))

g4 = imadjust(g,[],[],10);
figure, imshow(g4), title('gamma 10')
m = min(g4(:))
M = max(g4(:))