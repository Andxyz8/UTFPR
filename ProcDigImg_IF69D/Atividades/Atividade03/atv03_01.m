close all; clear all; clc;

function [lut] = get_lut(slope)
    x = 0:1:255;
    inflec = 127;

    lut_aux = 1./(1 + exp(-slope*(x - inflec)));

    lut = mat2gray(lut_aux);
    lut = uint8(lut.*255);
end

%Sigmoid

% Aloca uint8
% para depois usar funcao intlut (y1 é a LUT)
% Equação da sigmoide

slope = 0.05;
inflec = 127;

x = 0:1:255;

y1 = 1./(1 + exp(-slope*(x - inflec)));

y1n = mat2gray(y1);
y1n = uint8(y1n.*255);

% Display
figure, plot(y1n)
xlim([0 255]), ylim([0 255])
grid on
title('Sigmoide')
xlabel('x'), ylabel('y')

% Leitura da imagem
A = imread('vpfig.png');

% Img original
figure, imshow(A);
title('Imagem original')

var = 0.0005;

for n = 1:1:5
    lut = get_lut(var);

    An = intlut(A, lut);

    figure, imshow(An);
    title(['Slope ', num2str(var)])

    var = 10*var;
end
