close all; clear all; clc;

G = imread('cameraman.tif');

nr = size(G,1);
nc = size(G,2);
[X,Y] = meshgrid(1:nr,1:nc);
N = nr*nc;
I = [
    X(:)';
    Y(:)';
    ones(1,N)
];

ang = 30*pi/180;
T = [
    cos(ang) sin(ang) 0;
    -sin(ang) cos(ang) 0;
    0 0 1
];

K = T*I;

temp1 = min(K, [], 2);
m = repmat(temp1, 1, N);
temp2 = K - m;
Kadj = 1 + floor(temp2);

nrOut = max(Kadj(1,:));
ncOut = max(Kadj(2,:));
Gout = uint8(zeros(nrOut, ncOut));

for k = 1:length(Kadj)
 Gout(Kadj(1,k), Kadj(2,k)) = G(I(1,k), I(2,k));
end

imshow(Gout);

% POR QUE APARECEM PIXELS PRETOS ("BURACOS") NA IMAGEM ROTACIONADA?
% 
% Isto ocorre, pois em transformações geométricas de forward mapping
% (ou source-to-target) pode acontecer dos pixels ficarem sobrepostos,
% casionando a aparição dos pixels pretos na imagem de saída.

% Para evitar esse acontecimento, recomenda-se utilizar o mapeamento
% conhecido como backward mapping (ou target-to-source), que ao invés
% de realizar a transformação levando como base os pixels da imagem
% de entrada para gerar os pixels na imagem de saída, ele faz o processo
% inverso utilizando os pixels da imagem de saída para mapear estes
% pixels na imagem de entrada. Matematicamente, podemos fazer isso
% ao obter a inversa da matriz de transformação.