% mmse_filter [script]

clc, clear, close all

% usa nlfilter para achar var local
% e fspecial para achar media local

gorig = imread('Lenna256g.png');
figure, imshow(gorig), title('Original')

% Insere ruido Gaussiano m = 0 e desvio padrão = 10
g = imnoise(gorig,'gaussian',(0/255),(10/255)^2);
figure, imshow(g), title('Com ruido')

% Interação para selecionar região do ruido
disp('Selecione uma região para estimar a variância do ruído.')
[reg, rect] = imcrop(g);
% rect = [xmin ymin width height]
imin = ceil(rect(2)); %linha cse
jmin = ceil(rect(1)); %coluna cse
imax = floor(rect(2)+rect(4)); %linha cid
jmax = floor(rect(1)+rect(3)); %coluna cid
disp('Coodenadas da região selecionada')
disp(['Linha do canto superior esquerdo: ' num2str(imin)])
disp(['Coluna do canto superior esquerdo: ' num2str(jmin)])
disp(['Linha do canto inferior direito: ' num2str(imax)])
disp(['Coluna do canto inferior direito: ' num2str(jmax)])

g = double(g);
vnoise = var(double(reg(:)));

nrcw = 5; % numero de linhas e colunas da janela

% Imagem com as variâncias locais
fun = @(x)var(x(:));
vlocal = nlfilter(g,[nrcw nrcw],fun);
figure, imshow(mat2gray(vlocal)), title('Variâncias')

% Imagem com as médias locais
h = fspecial('average', [nrcw nrcw]);
mlocal = imfilter(g, h, 0);
figure, imshow(uint8(mlocal)), title('Média 5x5');

% Filtro
out = (1 - (vnoise./vlocal)).*g + (vnoise./vlocal).*mlocal;
out = uint8(out);
figure, imshow(out), title('MMSE 5x5');