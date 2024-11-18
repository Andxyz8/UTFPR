close all; clear all; clc;

img = imread("rice.png");

figure;
imshow(img);
title("Imagem Original");

vizinhancas = [5, 15, 25, 35, 45];
sensibilidades = [0.2, 0.4, 0.5, 0.6, 0.8];

figure;
n_subplot = 1;

for i = 1:length(vizinhancas)
    for j = 1:length(sensibilidades)
        adapt_t = adaptthresh( ...
            img, ...
            sensibilidades(j), ...
            "NeighborhoodSize", ...
            vizinhancas(i) ...
        );

        bw = imbinarize(img, adapt_t);

        subplot(length(vizinhancas), length(sensibilidades), n_subplot);
        imshow(bw);
        title( ...
            sprintf( ...
                "S: %d, t: %.1f", ...
                vizinhancas(i), ...
                sensibilidades(j) ...
            ) ...
        );

        n_subplot = n_subplot + 1;
    end
end
