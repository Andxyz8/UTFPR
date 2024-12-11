close all; clear all; clc;

folder = pwd; 
image_files = dir(fullfile(folder, '*.png'));  

resultado = [];

for k = 1:length(image_files)
    img_path = fullfile(folder, image_files(k).name);
    img = imread(img_path);
    
    y=272
    x=245
    width=20
    height = 100
    
    p1 = img(y:y+height-1, x:x+width-1, :)
    
    y=250
    x=400
    width=20
    height = 100
    
    p2 = img(y:y+height-1, x:x+width-1, :)
    
    y=128
    x=477
    width=20
    height = 100
    
    p3 = img(y:y+height-1, x:x+width-1, :)
    
    counts1 = count_colors(p1);
    counts2 = count_colors(p2);
    counts3 = count_colors(p3);
    
    if counts1(1) >= counts2(1) && counts1(1) >= counts3(1)
        y = 1;
    elseif counts2(1) >= counts3(1)
        y =2;
    else 
        y = 3;
    end
    
    if counts1(2) >= counts2(2) && counts1(2) >= counts3(2)
        r = 1;
    elseif counts2(2) >= counts3(2)
        r =2;
    else 
        r = 3;
    end
    
    if counts1(3) >= counts2(3) && counts1(3) >= counts3(3)
        b = 1;
    elseif counts2(3) >= counts3(3)
        b =2;
    else 
        b = 3;
    end
    
    if counts1(4) >= counts2(4) && counts1(4) >= counts3(4)
        g = 1;
    elseif counts2(4) >= counts3(4)
        g =2;
    else 
        g = 3;
    end
    
    if counts1(5) >= counts2(5) && counts1(5) >= counts3(5)
        o = 1;
    elseif counts2(5) >= counts3(5)
        o =2;
    else 
        o = 3;
    end

    resultado = [resultado; y, r, b, g, o];
end

save('resultado.mat', 'resultado');

function color_counts = count_colors(img)
    [rows, cols, ~] = size(img);
    yellow_count = 0;
    red_count = 0;
    blue_count = 0;
    green_count = 0;
    orange_count = 0;

    for i = 1:rows
        for j = 1:cols
            r = img(i, j, 1);
            g = img(i, j, 2);
            b = img(i, j, 3);

            if r >= 180 && r <= 200 && g >= 170 && g <= 190 && b >= 40 && b <= 60
                yellow_count = yellow_count + 1;

            elseif r >= 190 && r <= 210 && g >= 30 && g <= 50 && b >= 40 && b <= 60
                red_count = red_count + 1;

            elseif r >= 10 && r <= 30 && g >= 70 && g <= 90 && b >= 150 && b <= 170
                blue_count = blue_count + 1;

            elseif r >= 0 && r <= 20 && g >= 130 && g <= 150 && b >= 30 && b <= 50
                green_count = green_count + 1;

            elseif r >= 180 && r <= 200 && g >= 80 && g <= 100 && b >= 20 && b <= 40
                orange_count = orange_count + 1;
            end
        end
    end
color_counts = [yellow_count, red_count, blue_count, green_count, orange_count];
end