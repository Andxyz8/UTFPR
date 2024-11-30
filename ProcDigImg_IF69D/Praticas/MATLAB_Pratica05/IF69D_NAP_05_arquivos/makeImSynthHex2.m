function  s = makeImSynthHex2(M, obj, bck, sd)
% Cria uma imagem sintética uint8 de dimensões
% M linhas e M colunas. O objeto tem nível de
% cinza obj e o fundo tem nível de cinza bck.
% O centro tem nível de cinza zero.
% Adiciona ruído Gaussiano de desvio padrão sd.

nrhs = floor(M/2);
nchs = floor(M/2);

a = triu(ones(nrhs,nchs))*bck;
b = tril(ones(nrhs,nchs),-1)*obj;
g1 = uint8(a+b);
g2 = fliplr(g1);
g3 = flipud(g2);
g4 = flipud(g1);
s = [g2 g1; g3 g4];
[r c] = size(s);
g5 = ones(r,c);
g5(round(nrhs/4):end-(round(nrhs/4)),round(nchs/4):end-(round(nchs/4))) = 0;
idx = g5 == 1;
s(idx) = bck;
% achei q seria + fácil :-)
% deve existir uma maneira mais esperta...

circ = fspecial('gaussian', [r c], r/10);
circ = circ < max(circ(:))/1.5;
s = s .* uint8(circ);

% % Suaviza, para o degrau não ser ideal
% h = fspecial('average', [3 3]);
% s = imfilter(s, h, 'replicate');
% Um ruidinho de média zero e desvio padrão sd
s = imnoise(s,'gaussian',(0/255),(sd/255)^2);