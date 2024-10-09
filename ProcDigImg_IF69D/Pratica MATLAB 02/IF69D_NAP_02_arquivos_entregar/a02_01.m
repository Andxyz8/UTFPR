% a02_01 [script]

clc, clear, close all

gmb = imread('gDSC04422.png');
figure, imshow(gmb);

m = size(gmb,1);
n = size(gmb,2);
p = m/4;
q = n/4;
X = gmb;
Y = reshape( X, [ p m/p n ] );
Y = permute( Y, [ 1 3 2 ] );
Y = reshape( Y, [ p q m*n/(p*q) ] );
% Y(:,:,1) é uma das 16 imagens,
% Y(:,:,2) é outra...

% Mostrando uma das 16
figure,
imshow(Y(:,:,10)), title('Y(:,:,10)')
figure
imshow(mat2gray(Y(:,:,10))), title('Y(:,:,10) AC')

% Média 1
% Sc = imlincomb(1/3,X,1/3,Y,1/3,Z,'uint8')
M1 = imlincomb(1/16,Y(:,:,1),1/16,Y(:,:,2),...
    1/16,Y(:,:,3),1/16,Y(:,:,4),1/16,Y(:,:,5),...
    1/16,Y(:,:,6),1/16,Y(:,:,7),1/16,Y(:,:,8),...
    1/16,Y(:,:,9),1/16,Y(:,:,10),1/16,Y(:,:,11),...
    1/16,Y(:,:,12),1/16,Y(:,:,13),1/16,Y(:,:,14),...
    1/16,Y(:,:,15),1/16,Y(:,:,16),'uint8');
figure
imshow(M1), title('M1')
figure
imshow(mat2gray(M1)), title('M1 AC')

% Média 2 (de outro jeito)
Yd = double(Y);
M2 = mean(Y,3);
M2 = uint8(M2);
figure, imshow(M2), title('M2')
figure
imshow(mat2gray(M2)), title('M2 AC')