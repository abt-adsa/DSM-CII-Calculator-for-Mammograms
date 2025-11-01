% mainScript.m

%{
Implementation of Distribution Similarity Measure (DSM) and Contrast
Improvement Index (CII) calculation in MATLAB 
%}

clc
close all
clearvars

% --- Configuration ---
background_width = 15; % Width of the local background ring in pixels

% Read image
im = imread('test/mdb038.pgm');
im = im2gray(im);

% Image processing algorithm
% In this case, we use a simple histogram equalization
imProcessed = histeq(im);

% Prompt ROI selection and obtain ROI rectangle properties
fprintf('Please select the Region of Interest.\n');
[imRoi, roiRect] = imcrop(im);

% Normalize pixel values
im = im2double(im);
imProcessed = im2double(imProcessed);

% Calculate DSM and CII
% dsm = calculateDSM(im, imProcessed, roiRect); % Commented out until DSM is updated
cii = calculateLocalCII(im, imProcessed, roiRect, background_width);

% --- Visualization ---
figure
montage({im, imProcessed})
title(sprintf('Original vs. Processed (CII = %.2f)', cii))

% Draw ROI on the montage
hold on
% The montage function combines images, so we must adjust the rectangle's x-coordinate
montage_rect1 = roiRect;
montage_rect2 = roiRect;
montage_rect2(1) = montage_rect2(1) + size(im, 2); % Shift second rectangle to the right

rectangle('Position', montage_rect1, 'EdgeColor', 'r', 'LineWidth', 1);
rectangle('Position', montage_rect2, 'EdgeColor', 'r', 'LineWidth', 1);
hold off


