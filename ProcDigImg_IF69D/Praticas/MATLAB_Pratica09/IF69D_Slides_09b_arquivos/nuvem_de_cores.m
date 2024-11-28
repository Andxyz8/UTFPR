% nuvem_de_cores [script]

clc, clear, close all

img = imread("allColors32k.png");
imshow(img)

colorcloud(img)

colorcloud(img,"hsv")