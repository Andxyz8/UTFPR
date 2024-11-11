% adbteo_09 [script]
clc, clear, close all
 
% Gera um LoG de sigma=4 em uma janela 31x31
logf = fspecial('log', [31 31], 4);
p = logf(16,:); %linha central
 
%Dysplay
figure
mesh(-logf, 'EdgeColor', 'black')
title('LoG sigma=4')
figure
plot(1:31,-p,'LineWidth',2)
xlim([1 31])
grid
title('Perfil do LoG')