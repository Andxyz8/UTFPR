% a02_pre_02_doubleUint [script]

% Rode o código abaixo e responda as questões 

clc, clear, close all
 
g = imread('pout.tif');
mg=min(g(:));
Mg=max(g(:));
figure, imshow(g), title('g')

g1=double(g);
mg1=min(g1(:));
Mg1=max(g1(:));
figure, imshow(g1); title('g1')

g2=im2double(g);
mg2=min(g2(:));
Mg2=max(g2(:));
figure, imshow(g2), title('g2')

g3=mat2gray(g);
mg3=min(g3(:));
Mg3=max(g3(:));
figure, imshow(g3), title('g3')
 
% Questões

% g é da classe:
% Mín em g:  , Máx em g:

% g1 é da classe:
% Mín. em g1:   , Máx em g1:

% imshow(g1) mostra uma imagem: 
% porque:

% g2 é da classe: 
% Mín em g2:  , Máx em g2:

% g3 é da classe:
% Mín em g3:  , Máx em g3:   

% Qual é a diferença entre as funções
% im2double e mat2gray?