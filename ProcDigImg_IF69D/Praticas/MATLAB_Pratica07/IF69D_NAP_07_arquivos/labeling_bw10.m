% labeling_bw10 [script]
clc, clear, close all
 
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
 
% A saída de bwlabel
% é da classe double
[rv4 nrv4] = bwlabel(bw, 4);
[rv8 nrv8] = bwlabel(bw, 8);
 
% Aplica pseudocores na
% imagem rotulada para 
% visualização
rv4rgb = label2rgb(rv4);
rv8rgb = label2rgb(rv8);
disp(['n. obj em rv4 = ',...
    num2str(nrv4)])
disp(['n. obj em rv8 = ',...
    num2str(nrv8)])

% Display
figure, image(rv4rgb)
title('rv4rgb')
figure, image(rv8rgb)
title('rv8rgb')
