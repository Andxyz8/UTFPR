% color_19_euclidean [script]

clc, clear, %close all
%Tem que ter o tootlbox de estatística instalado no MATLAB

rgb = imread('shark1.jpg');

figure, imshow(rgb), title(rgb);
nr = size(rgb,1);
nc = size(rgb,2);
np = nr*nc;

% reorganiza pra passar pro k-means
rgbCols = reshape(rgb, np, 3);
rgbColsd = double(rgbCols);
% fazer o seguinte na command window pra conferir:
% rgb(1,1,:)
% rgbCols(1,:)
% rgb(2,1,:)
% rgbCols(2,:)

K = 8;

% K-medoids (distância euclidiana) no RGB
idx1 = kmedoids(rgbColsd, K, 'Distance', 'euclidean');
x1 = reshape(idx1, nr, nc);
x1L = label2rgb(x1);
figure, imshow(x1L), title('K-means RGB')

% Agora testando K-medoids no L*a*b*
labCols = rgb2lab(rgbColsd);
idx4 = kmedoids(labCols, K, 'Distance', 'euclidean');
x4 = reshape(idx4, nr, nc);
x4L = label2rgb(x4);
figure, imshow(x4L), title('K-means L*a*b*')

% Minimum variance quantization do MATLAB (RGB)
[X_q, cmap_q] = rgb2ind(rgb,K,'nodither');
figure , imshow(X_q , cmap_q), title('rgb2ind cor do centro do cubo')
figure , imshow(X_q , colormap(jet(K))), title('rgb2ind pseudocores')