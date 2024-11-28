% color_02 [script]

clear, clc, close all

rgb = imread('hotwheels09m.png');
figure, imshow(rgb);

r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);

r_g_b = [r g b]; %ver tb montage()
figure, imshow(r_g_b), title('r\_g\_b')

% Segmenta o objeto red car
redcar = imsubtract(r, g); 
figure, imshow(redcar), title('canal R - canal G')
th = graythresh(redcar);
redcar_bw = im2bw(redcar, th);
figure, imshow(redcar_bw), title('BW mask')

se = strel ("square", 7);
redcar_bw2 = imclose(redcar_bw, se);
figure, imshow(redcar_bw2), title('Closing em BW mask')
se = strel ("square", 3);
redcar_bw3 = imopen(redcar_bw2, se);
figure, imshow(redcar_bw3), title('Opening em BW mask')
redcar_bw4 = imfill(redcar_bw3, 'holes');
figure, imshow(redcar_bw4), title('Fill holes em BW mask')
%ver tb bwmorph()

% Localiza o objeto (cetróide=centro de massa). 
% Função 'regionprops' é show!
% https://www.mathworks.com/help/images/ref/regionprops.html
% Calcula várias propriedades dos componentes conexos.
% Geralmente a entrada é uma imagem rotulada (saída da função bwlabel).
c = regionprops(redcar_bw4, 'Centroid');
% Marca o centróide
figure, imshow(redcar_bw4), title('Centróide')
hold on;
plot(c.Centroid(1), c.Centroid(2), 'r+', 'MarkerSize', 20, 'LineWidth', 2);
hold off;

% Contorno verde
perim_bw = bwperim(redcar_bw4, 8);
figure, imshow(perim_bw), title('Perímetro de BW mask')
g_sat = g; %sat: saturado
g_sat(perim_bw) = 255;
rgb2 = cat(3, r, g_sat, b);
figure, imshow(rgb2), title('Perímetro na imagem RGB')

% Escurece o que não é objeto
redcar_bw4d = double(redcar_bw4);
redcar_bw4dn = ~redcar_bw4;
figure, imshow(redcar_bw4dn), title('NOT de BW Mask')
redcar_bw4d(redcar_bw4dn) = 0.2; % apenas onde não é objeto
figure, imshow(redcar_bw4d), title('Para atenuar canais R G B')
rgb3 =  double(rgb) .* repmat(redcar_bw4d, [1 1 3]);
rgb3 = uint8(rgb3);
figure, imshow(rgb3), title('Destaque na imagem RGB')

% imwrite(redcar, 'color_02_redcar.png');
% imwrite(redcar_bw, 'color_02_redcar_bw.png');
% imwrite(redcar_bw2, 'color_02_redcar_bw2.png');
% imwrite(redcar_bw3, 'color_02_redcar_bw3.png');
% imwrite(redcar_bw4, 'color_02_redcar_bw4.png');
% imwrite(perim_bw, 'color_02_perim_bw.png');
% imwrite(rgb2, 'color_02_rgb2.png');
% imwrite(redcar_bw4dn, 'color_02_redcar_bw4dn.png');
% imwrite(redcar_bw4d, 'color_02_redcar_bw4d.png');
% imwrite(rgb3, 'color_02_rgb3.png');