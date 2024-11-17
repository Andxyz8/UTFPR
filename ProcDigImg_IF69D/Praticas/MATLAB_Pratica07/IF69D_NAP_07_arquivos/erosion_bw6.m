% erosion_bw6 [script]
clc, clear, close all
imtool close all
 
bw = [ 1 0 0 0 0 1
       0 0 1 1 0 0
       0 0 1 0 0 0
       0 1 1 1 1 0
       0 1 1 1 0 0
       0 0 0 0 0 0];
 
bw = logical(bw);
 
% O hot spot é dado por floor((size(NHOOD)+1)/2)
% Logo, o hotspot do elemento estruturante abaixo é em (1,1)
NHOOD = [ 1 0
          1 1 ];
SE = strel('arbitrary', NHOOD);
e = imerode(bw, SE);
 
imtool(bw)
imtool(e)