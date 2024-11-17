function v = visualize(bwo, bwp)
% v: saida uint8
% bwo: bw original
% bwp: bw processada
% 0 em bwo -> 0 em bwp: 0 em v,
% 1 em bwo -> 1 em bwp: 1 em v,
% 0 em bwo -> 1 em bwp: 170 em v, (cinza claro)
% 1 em bwo -> 0 em bwp: 85 em v,  (cinza escuro)
 
v = uint8(bwo & bwp)*255;   % 1 em bwo -> 1 em bwp: 1 em v
idx = (bwo==0 & bwp==1);    % 0 em bwo -> 1 em bwp: 170 em v
v(idx) = 170;
idx = (bwo==1 & bwp==0);    % 1 em bwo -> 0 em bwp: 85 em v
v(idx) = 85;
