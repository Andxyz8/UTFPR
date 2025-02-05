function algoritmo_seam_carving(caminho_imagem, num_seams_vertical, num_seams_horizontal, operacao)
    
    img = imread(caminho_imagem);
    img = im2double(img);

    mapa_energia = get_mapa_energia(img);
    figure, imagesc(mapa_energia), colormap(jet), colorbar, title('Mapa inicial de Energia');
    saveas(gcf, sprintf('%s_mapa_calor_inicial.png', caminho_imagem));

    media_inicial_energia = mean(mapa_energia(:));
    fprintf('Média inicial de energia: %.4f\n', media_inicial_energia);

    if strcmp(operacao, 'add')
        seams_verticais = get_seam_vertical(mapa_energia, num_seams_vertical);
    end

    if strcmp(operacao, 'remove')
        for i = 1:num_seams_vertical
            mapa_energia = get_mapa_energia(img);
            seam = get_seam_vertical(mapa_energia, 1);
            img = remove_seam_vertical(img, seam);
        end
    end

    if strcmp(operacao, 'add')
        for i = num_seams_vertical:-1:1
            img = add_seam_vertical(img, seams_verticais(:, i));
        end
    end

    if strcmp(operacao, 'add')
        mapa_energia = get_mapa_energia(img);
        seams_horizontais = get_seam_horizontal(mapa_energia, num_seams_horizontal);
    end

    if strcmp(operacao, 'remove')
        for i = 1:num_seams_horizontal
            mapa_energia = get_mapa_energia(img);
            seam = get_seam_horizontal(mapa_energia, 1);
            img = remove_seam_horizontal(img, seam);
        end
    end

    if strcmp(operacao, 'add')
        for i = num_seams_horizontal:-1:1
            img = add_seam_horizontal(img, seams_horizontais(:, i));
        end
    end

    mapa_energia_final = get_mapa_energia(img);
    figure, imagesc(mapa_energia_final), colormap(jet), colorbar, title('Mapa final de energia');
    saveas(gcf, sprintf('%s_mapa_calor_final.png', caminho_imagem));

    media_final_energia = mean(mapa_energia_final(:));
    fprintf('Média de energia final: %.4f\n', media_final_energia);

    imwrite(img, sprintf('%s_%s_final_resized_image.png', caminho_imagem, operacao));
    figure, imshow(img), title('Final Resized Image');
end

function mapa_energia = get_mapa_energia(img)
    if size(img, 3) == 3
        gray_img = rgb2gray(img);
    else
        gray_img = img;
    end
    [gx, gy] = gradient(double(gray_img));
    mapa_energia = abs(gx) + abs(gy);
end

function seams = get_seam_vertical(mapa_energia, num_seams)
    [lin, col] = size(mapa_energia);
    seams = zeros(lin, num_seams);
    M = mapa_energia;
    backtrack = zeros(size(M));

    for i = 2:lin
        for j = 1:col
            if j == 1
                [min_val, idx] = min(M(i-1, j:j+1));
                idx = idx + j - 1;
            elseif j == col
                [min_val, idx] = min(M(i-1, j-1:j));
                idx = idx + j - 2;
            else
                [min_val, idx] = min(M(i-1, j-1:j+1));
                idx = idx + j - 2;
            end
            M(i, j) = M(i, j) + min_val;
            backtrack(i, j) = idx;
        end
    end

    for s = 1:num_seams
        [~, minIndex] = min(M(end, :));
        seam = zeros(lin, 1);
        seam(end) = minIndex;

        for i = lin-1:-1:1
            seam(i) = backtrack(i+1, seam(i+1));
        end

        seams(:, s) = seam;
        M(:, seam) = Inf; 
    end
end

function img = remove_seam_vertical(img, seam)
    [lin, col, canais] = size(img);
    for i = 1:lin
        for c = 1:canais
            img(i, seam(i):col-1, c) = img(i, seam(i)+1:col, c);
        end
    end
    img = img(:, 1:col-1, :);
end

function seams = get_seam_horizontal(mapa_energia, num_seams)
    seams = get_seam_vertical(mapa_energia', num_seams);
end

function img = remove_seam_horizontal(img, seam)
    img = permute(img, [2, 1, 3]);
    img = remove_seam_vertical(img, seam);
    img = permute(img, [2, 1, 3]);
end

function img = add_seam_vertical(img, seam)
    [lin, col, canais] = size(img);
    output = zeros(lin, col+1, canais);
    for i = 1:lin
        seamCol = seam(i);
        for c = 1:canais
            output(i, 1:seamCol, c) = img(i, 1:seamCol, c);
            output(i, seamCol+1, c) = mean([img(i, seamCol, c), img(i, min(seamCol+1, col), c)]);
            output(i, seamCol+2:end, c) = img(i, seamCol+1:end, c);
        end
    end
    img = output;
end

function img = add_seam_horizontal(img, seam)
    img = permute(img, [2, 1, 3]);
    img = add_seam_vertical(img, seam);
    img = permute(img, [2, 1, 3]);
end
