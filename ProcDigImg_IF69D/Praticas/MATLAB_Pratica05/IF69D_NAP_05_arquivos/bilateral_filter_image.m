% bilateral_filter_image [script]
clc, clear, close all
imtool close all
% ------------------------------------------------------------------- USER
img = imread('carro1mm.jpg'); %dk_sigma = 3; rk_sigma = 0.2;
% img = imread('chicomm.jpg'); %dk_sigma = 3; rk_sigma = 0.2;
% img = imread('carro1mm_bf1.png'); %dk_sigma = 3; rk_sigma = 0.2; iterativo pq carro1mm_bf1.png é a saída de um bilateral filter dk_sigma = 3; rk_sigma = 0.2
% img = imnoise(checkerboard(80),'gaussian',0,0.02); %dk_sigma = 10; rk_sigma = 0.8;
% img = imread('cameraman.tif'); %dk_sigma = 3; rk_sigma = 0.2;
% img = imread('rice.png'); %dk_sigma = 3; rk_sigma = 0.2;

dk_sigma = 3; % domain (Gaussian) kernel sigma. Kernel size is a function of sigma
rk_sigma = 0.2; % range kernel sigma
% --------------------------------------------------------------- END USER

img = im2gray(im2double(img));
[nr, nc] = size(img); % Image number of rows and cols
wk_s = 2*ceil(2*dk_sigma)+1; % kernel square size
tl = -floor(wk_s/2); % row==col of the top left limit of rk
br = floor(wk_s/2); % row==col of the bottom right limit of rk
dk = fspecial("gaussian", wk_s, dk_sigma);

img_f = zeros(nr,nc);
for i = br+1:nr-br
    for j = br+1:nc-br
        img_p = ones(wk_s)*img(i,j); % patch filled with value of THE PIXEL p
        img_patch = img(i+tl:i+br,j+tl:j+br);
        rk = exp(-((img_p - img_patch).^2)/(2*(rk_sigma^2)));
        wk = dk.*rk;
        wk = wk/sum(wk(:)); % make sum(wk(:)) = 1
        img_f(i,j) = sum(sum(img_patch.*wk)); % MAC (multiply–accumulate)
    end
end

figure,
imshow(img, Border="tight")
figure, imshow(img_f, Border="tight")
figure, imshow(imgaussfilt(img,dk_sigma), Border="tight");
figure, imshow(imgaussfilt(img,1+rk_sigma), Border="tight");

% montage({img,img_f,imgaussfilt(img,dk_sigma),imgaussfilt(img,rk_sigma)})

% imshow([img img_f imgaussfilt(img,dk_sigma)], Border="tight")