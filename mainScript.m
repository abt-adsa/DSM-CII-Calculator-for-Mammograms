% mainScript.m

%{
Implementation of Distribution Similarity Measure (DSM) and Contrast
Improvement Index (CII) calculation in MATLAB 
%}

clc
close all
clearvars

im = imread('test/mdb038.pgm');
im = im2gray(im);
imProcessed = histeq(im);

[imFore, cropSize] = imcrop(im);

im = im2double(im);
imProcessed = im2double(imProcessed);

cii = calculateCII(im, imProcessed, cropSize);
dsm = calculateDSM(im, imProcessed, cropSize);

figure
montage({im, imProcessed})
title(sprintf("CII = %s; DSM = %s", cii, dsm))

