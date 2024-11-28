close all; clear all; clc;

tam_img = 256;
tam_quadrado = 60;
tam_translacao_x = -50;
tam_translacao_y = 50;
ang_rotacao = pi / 4; % 

% Quadrado no centro
img1 = zeros(tam_img);
centro = tam_img / 2;
img1( ...
    centro - tam_quadrado/2:centro + tam_quadrado/2, ...
    centro - tam_quadrado/2:centro + tam_quadrado/2 ...
    ) = 1;

% Quadrado deslocado
img2 = zeros(tam_img);
img2(( ...
        centro - tam_quadrado/2 + tam_translacao_y ...
    ):( ...
        centro + tam_quadrado/2 + tam_translacao_y ...
    ), ( ...
        centro - tam_quadrado/2 + tam_translacao_x ...
    ):( ...
        centro + tam_quadrado/2 + tam_translacao_x ...
    )) = 1;

% Quadrado rotacionado
matriz_rotacao = [
    cos(ang_rotacao), -sin(ang_rotacao);
    sin(ang_rotacao), cos(ang_rotacao)
];
coords_quad = [
    -tam_quadrado/2, -tam_quadrado/2;
    tam_quadrado/2, -tam_quadrado/2;
    tam_quadrado/2, tam_quadrado/2;
    -tam_quadrado/2, tam_quadrado/2
]';
coords_quad_rot = matriz_rotacao * coords_quad;
coords_quad_rot = round(coords_quad_rot + centro);

img3 = zeros(tam_img);
poly_mask = poly2mask( ...
    coords_quad_rot(1, :), ...
    coords_quad_rot(2, :), ...
    tam_img, ...
    tam_img ...
);
img3(poly_mask) = 1;


% Centralizado
img_fft1 = fft2(img1);
img_fft1_s = fftshift(img_fft1);
img_fft1_m = log(1 + abs(img_fft1_s));
img_fft1_m_v = mat2gray(img_fft1_m);

% Translação
img_fft2 = fft2(img2);
img_fft2_s = fftshift(img_fft2);
img_fft2_m = log(1 + abs(img_fft2_s));
img_fft2_m_v = mat2gray(img_fft2_m);

% Rotação
img_fft3 = fft2(img3);
img_fft3_s = fftshift(img_fft3 );
img_fft3_m = log(1 + abs(img_fft3_s));
img_fft3_m_v = mat2gray(img_fft3_m);


figure;

subplot(3, 2, 1);
imshow(img1);
title('Quadrado centralizado');
subplot(3, 2, 2);
imshow(img_fft1_m_v);
title('Espectro 1');

subplot(3, 2, 3);
imshow(img2, []);
title('Quadrado deslocado');
subplot(3, 2, 4);
imshow(img_fft2_m_v);
title('Espectro 2');

subplot(3, 2, 5);
imshow(img3, []);
title('Quadrado rotacionado');
subplot(3, 2, 6);
imshow(img_fft3_m_v);
title('Espectro 3');
