% tophat_rice [script]
clc, clear, close all

g = imread('rice.png');
figure
h = tiledlayout(3,3);
h.TileSpacing = 'tight';
h.Padding = 'compact';
nexttile, imshow(g); title('Original')

SE = strel('disk',15);
ge = imerode(g, SE);
nexttile, imshow(ge); title('Erosion')
ged = imdilate(ge, SE);
nexttile, imshow(ged);
title('Erosion -> Dilation')

gtophat = imsubtract(g, ged);
nexttile, imshow(gtophat)
title('My top-hat')
tophat = imtophat(g, SE);
nexttile, imshow(tophat)
title('imtophat()')
tophat_n = mat2gray(tophat);
nexttile, imshow(tophat_n);
title('Normalized imtophat()')

t = graythresh(tophat_n);
tophat_bw = im2bw(tophat_n, t);
nexttile([1 3]), imshow(tophat_bw);
title('Global th on normalized top-hat')