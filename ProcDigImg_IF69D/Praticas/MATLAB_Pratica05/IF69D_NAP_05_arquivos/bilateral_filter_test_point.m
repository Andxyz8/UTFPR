% bilateral_filter_test_point [script]
% DANGER memory boom
clc, clear, close all
imtool close all
% ------------------------------------------------------------------- USER
w = 256; % dk_sigma = 3; rk_sigma = 0.2;
objt = 192; fundo = 64; rnd = 7;
img = makeImSynthHex2(w,objt,fundo,rnd);
tpoint = [31 97; 32 98; 112 112; 113 113]; % makeImSynthHex2 w=256

dk_sigma = 3; % domain (Gaussian) kernel sigma. Kernel size is a function of sigma
rk_sigma = 0.2; % range kernel sigma
% --------------------------------------------------------------- END USER

img = im2gray(im2double(img));
[nr, nc] = size(img); % Image number of rows and cols
wk_s = 2*ceil(2*dk_sigma)+1; % kernel square size
tl = -floor(wk_s/2); % row==col of the top left limit of rk
br = floor(wk_s/2); % row==col of the bottom right limit of rk
dk = fspecial("gaussian", wk_s, dk_sigma);

% Bilateral filter
img_f = zeros(nr,nc);
img_patch(1:nr,1:nc) = {zeros(wk_s,wk_s)}; % all image patches
rk(1:nr,1:nc) = {zeros(wk_s,wk_s)}; % all correspondent range kernels
wk(1:nr,1:nc) = {zeros(wk_s,wk_s)}; % all correspondent bilateral filter kernels
for i = br+1:nr-br
    for j = br+1:nc-br
        img_p = ones(wk_s)*img(i,j); % patch filled with value of THE PIXEL p
        img_patch(i,j) = {img(i+tl:i+br,j+tl:j+br)};
        rk(i,j) = {exp(-((img_p - img_patch{i,j}).^2)/(2*(rk_sigma^2)))};
        wk(i,j) = {dk.*rk{i,j}};
        wk(i,j) = {wk{i,j}/sum(sum(wk{i,j}))}; % make sum(wk(:,:,k)) = 1
        img_f(i,j) = sum(sum(img_patch{i,j}.*wk{i,j})); % MAC (multiply–accumulate)
    end
end

%%
figure
montage({img,img_f,imgaussfilt(img,dk_sigma)})

%% Test points tp(row,col) for the makeImSynthHex(w,objt,fundo,rnd) image
for tp = 1:size(tpoint,1)
    figure,
    t = tiledlayout(3,2);
    t.TileSpacing = 'tight'; t.Padding = 'compact';
    nexttile, imshow(img_patch{tpoint(tp,1),tpoint(tp,2)}), title('in')
    hold on
    plot(ceil(wk_s/2),ceil(wk_s/2),'r+')
    hold off
    nexttile, imagesc(img_patch{tpoint(tp,1),tpoint(tp,2)}), title('in')
    hold on
    plot(ceil(wk_s/2),ceil(wk_s/2),'r+')
    hold off  
    nexttile, imagesc(dk), title('dk')
    hold on
    plot(ceil(wk_s/2),ceil(wk_s/2),'r+')
    hold off
    nexttile, imagesc(rk{tpoint(tp,1),tpoint(tp,2)}), title('rk')
    hold on
    plot(ceil(wk_s/2),ceil(wk_s/2),'r+')
    hold off
    nexttile, imagesc(wk{tpoint(tp,1),tpoint(tp,2)}), title('dk.*rk') % bilat filter kernel
    hold on
    plot(ceil(wk_s/2),ceil(wk_s/2),'r+')
    hold off
    nexttile, imshow(img_f(tpoint(tp,1)+tl:tpoint(tp,1)+br,tpoint(tp,2)+tl:tpoint(tp,2)+br)), title('out')
    hold on
    plot(ceil(wk_s/2),ceil(wk_s/2),'r+')
    hold off
end