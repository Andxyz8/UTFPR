% color_19_imsegkmeans [script]

clc, clear, close all

rgb = imread('shark1.jpg');

figure, imshow(rgb), title('rgb');

K = 8;

% K-means no RGB
labels = imsegkmeans(rgb,K);
labeled_image = labeloverlay(rgb,labels);
figure, imshow(labeled_image), title('K-means no RGB');

% Agora testando K-means no L*a*b*
lab = rgb2lab(rgb); 
lab = im2single(lab); % se entrada é double, imsegkmeans requer im2single
labels = imsegkmeans(lab,K);
labeled_image = labeloverlay(rgb,labels);
figure, imshow(labeled_image), title('K-means no L*a*b*');

% Agora testando K-means só no croma (canais a* e b*) do L*a*b*
ab = lab(:,:,2:3); 
labels = imsegkmeans(ab,K);
labeled_image = labeloverlay(rgb,labels);
figure, imshow(labeled_image), title('K-means no a*b*');