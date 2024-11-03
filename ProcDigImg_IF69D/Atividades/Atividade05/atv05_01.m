close all; clear all; clc;

original = imread('einstein.gif');

% Lista imagens
imagens = {...
    'einstein.gif', ...
    'meanshift.gif', ...
    'contrast.gif', ...
    'impulse.gif', ...
    'blur.gif', ...
    'jpg.gif' ...
};

% Loop através das imagens para calcular MSE e SSIM
for i = 1:length(imagens)
    img = imread(imagens{i});

    mse_val = immse(original, img);

    ssim_val = ssim(original, img);

    fprintf('%s: MSE = %.4f, SSIM = %.4f\n', imagens{i}, mse_val, ssim_val);
end

% =======================================================================

% VALORES OBTIDOS DEMONSTRATION

% einstein.gif: MSE = 0.0000, SSIM = 1.0000
% meanshift.gif: MSE = 143.9945, SSIM = 0.9873
% contrast.gif: MSE = 144.2188, SSIM = 0.9012
% impulse.gif: MSE = 143.9390, SSIM = 0.8395
% blur.gif: MSE = 143.9085, SSIM = 0.7022
% jpg.gif: MSE = 141.9529, SSIM = 0.6699

% =======================================================================

% RESPOSTAS DAS QUESTÕES DE MÚLTIPLA ESCOLHA

% EXERCÍCIO 1.
% A 'Demonstration' foi reproduzida com sucesso?

% Resposta: (c)
% Sim. Embora os resultados possam não ser numericamente idênticos,
% são muitíssimos parecidos. 

% =======================================================================

% EXERCÍCIO 2.
% Por que o índice SSIM é melhor que o MSE neste experimento?

% Resposta: (b)
% Porque o MSE apresenta valores praticamente iguais para qualidades
% notavelmente diferentes das imagens, enquanto o SSIM captura essas
% diferenças, além de apresentar valores compatíveis com a noção de
% qualidade que seria atribuída por uma pessoa (SVH).
