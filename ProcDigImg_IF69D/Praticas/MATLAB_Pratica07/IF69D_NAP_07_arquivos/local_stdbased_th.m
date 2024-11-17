% local_stdbased_th [script]
% Tutorial 'Adaptive Thresholding',
% capítulo 15, páginas 382 até 384 do livro
% Oge Marques, Practical image and video
% processing using MATLAB, Wiley, 2011.

clc, clear, close all

g = imread('gradient_with_text.tif');
figure, imshow(g), title('Original')

% Global Th
ggth = im2bw(g, graythresh(g));
figure, imshow(ggth), title('Global th')

% Local Th
% Função blockproc é sem overlap
% Cria function handle
fun = @(myBlock) localThStd(myBlock.data);
gath = blockproc(g, [10 10], fun); % processa 
figure, imshow(gath), title('Local std-based th')


% =====
function y = localThStd(x)
% x: bloco da imagem (subimagem)
% y: bloco processado

  
  if(std2(x)) < 1 % std baixo -> é fundo
    % devolve um bloco de uns
    y = ones(size(x,1),size(x,2)); 
  else % std alto -> é texto
      % aplica Otsu no bloco e devolve
      y = im2bw(x, graythresh(x)); 
  end

end

% https://www.mathworks.com/help/images/ref/blockproc.html
% B = blockproc(A,blockSize,fun) processes the image A by applying
% the function fun to each distinct block of A and concatenating the
% results into B, the output matrix. blockSize is a two-element
% vector, [rows cols], that specifies the size of the block.
% fun is a handle to a function that accepts a block struct as
% input and returns a matrix, vector, or scalar Y. For example,
% Y = fun(block_struct). (For more information about a block struct,
% see the Definition section below.) For each block of data in the
% input image, A, blockproc passes the block in a block struct to the
% user function, fun, to produce Y, the corresponding
% block in the output image.

% A block struct is a MATLAB structure that contains the block data
% as well as other information about the block.
% Fields in the block struct are:
% ...
% block_struct.data: M-by-N or M-by-N-by-P matrix of block data
%...