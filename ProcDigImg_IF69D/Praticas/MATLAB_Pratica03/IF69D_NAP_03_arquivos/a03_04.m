% a03_04 [script]
clc, clear, close all

i = imread('42049_20-200.png');
figure, imshow(i), title('original')

i2 = mat2gray(i);
figure, imshow(i2), title('mat2gray')

%Function File: imadjust(I,[low_in high_in],[low_out high_out])
i3 = imadjust(i, [double(min(i(:)))/255 double(max(i(:)))/255], [0 1]);
figure, imshow(i3), title('imadjust auto-contraste (normalização, igual mat2gray)')

i4 = imadjust(i, stretchlim(i, 0.1), [0 1]);
figure, imshow(i4), title('imadjust 10% saturação, default é 1%')

f = double(i);
fmin = min(f(:));
fmax = max(f(:));
i5 = uint8((f-fmin)/(fmax-fmin) * 255);
figure, imshow(i5), title('auto-contraste equação')
