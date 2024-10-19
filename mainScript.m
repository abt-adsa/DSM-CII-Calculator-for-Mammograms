% mainScript.m

%{
Implementation of Distribution Similarity Measure (DSM) and Contrast
Improvement Index (CII) calculation in MATLAB 
%}

clc
close all
clearvars

% Read image
im = imread('test/mdb038.pgm');
im = im2gray(im);

% Image processing algorithm
% In this case, we use a simple histogram equalization
imProcessed = histeq(im);

% Prompt ROI selection and obtain ROI rectangle properties
[imRoi, roiRect] = imcrop(im);

% Normalize pixel values
im = im2double(im);
imProcessed = im2double(imProcessed);

% Calculate DSM and CII
dsm = calculateDSM(im, imProcessed, roiRect);
cii = calculateCII(im, imProcessed, roiRect);

figure
montage({im, imProcessed})
title(sprintf("DSM = %s; CII = %s", dsm, cii))

