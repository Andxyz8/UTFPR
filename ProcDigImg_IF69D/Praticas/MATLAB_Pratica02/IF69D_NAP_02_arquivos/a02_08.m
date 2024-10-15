% a02_08 [script]

clc, clear, close all

g = checkerboard;
figure
imshow(g), title('g')

gnn = imrotate(g, 45, 'nearest');
gbc = imrotate(g, 45, 'bicubic');

figure
imshow(gnn), title('nn')
figure
imshow(gbc), title('bc')