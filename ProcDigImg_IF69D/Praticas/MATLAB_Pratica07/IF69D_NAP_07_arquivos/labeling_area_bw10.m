% labeling_area_bw10 [script]
clc, clear, close all
imtool close all
 
bw = [ 0 0 0 0 0 0 0 0 0 0
       0 0 0 0 0 0 0 0 1 0
       0 0 1 1 1 0 0 1 0 0
       0 0 1 1 1 0 1 1 1 0
       0 0 0 0 0 1 1 1 0 0
       0 0 0 0 0 0 1 1 1 0
       0 0 0 1 0 0 0 1 1 0
       0 0 1 1 0 0 1 1 0 0 
       0 1 1 1 0 1 1 0 0 0
       0 0 0 0 0 0 0 0 0 0 ];
 
bw = logical(bw);   
[rv8 nobj] = bwlabel(bw, 8);
imshow(bw), title('bw')
impixelregion
 
% Aloca vetor para armazenar o número de pixels
% de cada objeto
area = zeros(1,nobj);
% Aloca cell array para armazenar os índices
% lineares de cada objeto
linearIdx = cell(1,nobj);
 
% Para cada objeto
for k = 1:nobj
    % Coordenadas lineares dos pixels do objeto k
    linearIdx{k} = find(rv8==k);
    % Número de pixels do objeto k
    area(k) = length(linearIdx{k});
    fprintf('Area em pixels do obj %d = %d\n', k, area(k));
end

% Elimina o objeto menor
bw2 = bw;
[valor idx] = min(area);
bw2(linearIdx{idx}) = 0;
figure, imshow(bw2), title('bw2')
impixelregion