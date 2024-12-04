% geraNota_hanoi_01_dev [script]
% Este é o template do script que o professor vai rodar para avaliar os
% resultados do seu algoritmo e atribuir a nota. Na versão do professor,
% os '?' estão preenchidos com os valores corretos.
% No momento da correção, o professor vai copiar as imagens faltantes junto
% com as demais (q vc deve incluir), rodar o seu script e depois este script.
% Portanto, a saída do seu script deve ser um arquivo 'resultado.mat'
% contendo uma variável 'resultado'. 'resultado' deve ser uma matriz 35x5.

clear, clc, close all

load resultado.mat; % resultado.mat é a saída do seu algoritmo
saidaAlgoritmo = resultado;

gabarito = [
%Y R B G L 
3 3 3 3 3;%hanoi_01_01
2 3 3 3 3;%hanoi_01_02
? ? ? ? ?;%hanoi_01_03 tst
2 1 1 3 3;%hanoi_01_04
? ? ? ? ?;%hanoi_01_05 tst
2 3 1 2 3;%hanoi_01_06
? ? ? ? ?;%hanoi_01_07 tst
1 2 2 3 1;%hanoi_01_08
? ? ? ? ?;%hanoi_01_09 tst
1 3 3 1 2;%hanoi_01_10
? ? ? ? ?;%hanoi_01_11 tst
? ? ? ? ?;%hanoi_01_12 tst
3 3 1 2 2;%hanoi_01_13
? ? ? ? ?;%hanoi_01_14 tst
? ? ? ? ?;%hanoi_01_15 tst
1 2 3 2 1;%hanoi_01_16
1 2 3 3 1;%hanoi_01_17
3 2 3 3 1;%hanoi_01_18
? ? ? ? ?;%hanoi_01_19 tst
3 2 3 1 1;%hanoi_01_20
3 1 3 1 1;%hanoi_01_21
? ? ? ? ?;%hanoi_01_22 tst
3 1 2 2 2;%hanoi_01_23
? ? ? ? ?;%hanoi_01_24 tst
2 3 2 2 2;%hanoi_01_25
3 3 2 1 2;%hanoi_01_26
3 3 1 1 2;%hanoi_01_27
? ? ? ? ?;%hanoi_01_28 tst
1 1 1 1 1;%hanoi_01_29
2 2 2 2 1;%hanoi_01_30
? ? ? ? ?;%hanoi_01_31 tst
? ? ? ? ?;%hanoi_01_32 tst
1 3 2 3 1;%hanoi_01_33
? ? ? ? ?;%hanoi_01_34 tst
1 3 3 3 1;%hanoi_01_35
];

errado = abs(saidaAlgoritmo - gabarito);
errado = logical(sum(errado, 2));
certo = ~errado;
certo_tst = certo([3 5 7 9 11 12 14 15 19 22 24 28 31 32 34])'