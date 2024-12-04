% color_20 [script]
% Source: https://github.com/ip-recipes-matlab-book
% Recipe 21, listing 21.1

clc, clear, close all
% Superpixel oversegmentation using SLIC
 
img = imread('lighthouse.png');

% Compute superpixels of the image for 4 different values
for number_superpixels = [100 200 500 1000]
    [label_matrix, ~] = superpixels(img, number_superpixels);
    % Show superpixels overlaid on image
    boundary_mask = boundarymask(label_matrix);
    figure, imshow(imoverlay(img,boundary_mask,'yellow'))
end

% Play with 'compactness' argument
number_superpixels = 500;
for compactness_value = [1 10 15 20]
    [label_matrix, ~] = superpixels(img, number_superpixels, ...
        Method="slic", Compactness=compactness_value);
    % Show superpixels overlaid on image
    boundary_mask = boundarymask(label_matrix);
    figure, imshow(imoverlay(img,boundary_mask,'yellow'))
end