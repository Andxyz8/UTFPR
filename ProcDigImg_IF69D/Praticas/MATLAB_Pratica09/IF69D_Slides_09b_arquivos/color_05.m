% color_05 [script]
clc, clear, close all

% (P)Rosa: "vermelho esbranquiçado"
%           vermelho dessaturado
%                    low S
% (L)Laranja: entre o vermelho
%             e o amarelo
% (Rr)Marrom: "laranja escuro"
%                      low V
%     P    L     Rr
H = [ 0   1/12  1/12];  
S = [0.5   1     1  ];
V = [ 1    1    0.5 ];

HSV = cat(3, H, S, V);
RGB = hsv2rgb(HSV);
figure, image(RGB);