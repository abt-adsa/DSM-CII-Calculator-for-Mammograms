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

% Get list of all .pgm files in the test directory
imageFiles = dir('test/*.pgm');

% Initialize a table to store results
resultsTable = table();

for i = 1:length(imageFiles)
    currentImageName = imageFiles(i).name;
    imagePath = fullfile('test', currentImageName);
    [~, name, ~] = fileparts(currentImageName);
    roiMatFilePath = fullfile('test', [name, '_roi.mat']);

    fprintf('Processing image: %s\n', currentImageName);

    % Read image
    im = imread(imagePath);
    im = im2gray(im);

    % Image processing algorithm
    % In this case, we use a simple histogram equalization
    imProcessed = histeq(im);

    % Make ROI selection reproducible
    if exist(roiMatFilePath, 'file')
        fprintf('Loading existing ROI for %s.\n', currentImageName);
        load(roiMatFilePath, 'roiRect');
    else
        fprintf('Please select the Region of Interest for %s.\n', currentImageName);
        figure; imshow(im); title(sprintf('Select ROI for %s', currentImageName));
        [~, roiRect] = imcrop(im);
        close(gcf); % Close the ROI selection figure
        save(roiMatFilePath, 'roiRect');
        fprintf('ROI saved for %s.\n', currentImageName);
    end

    % Normalize pixel values
    im = im2double(im);
    imProcessed = im2double(imProcessed);

    % Calculate DSM and CII
    dsm = calculateDSM(im, imProcessed, roiRect, background_width);
    cii = calculateLocalCII(im, imProcessed, roiRect, background_width);

    % Store results for current image
    newRow = {currentImageName, cii, dsm};
    resultsTable = [resultsTable; newRow]; %#ok<AGROW>

    % --- Visualization ---
    figure
    montage({im, imProcessed})
    title(sprintf('Original vs. Processed (CII = %.2f, DSM = %.2f) for %s', cii, dsm, currentImageName))

    % Draw ROI on the montage
    hold on
    % The montage function combines images, so we must adjust the rectangle's x-coordinate
    montage_rect1 = roiRect;
    montage_rect2 = roiRect;
    montage_rect2(1) = montage_rect2(1) + size(im, 2); % Shift second rectangle to the right

    rectangle('Position', montage_rect1, 'EdgeColor', 'r', 'LineWidth', 1);
    rectangle('Position', montage_rect2, 'EdgeColor', 'r', 'LineWidth', 1);
    hold off
end

% Define column names for the results table
resultsTable.Properties.VariableNames = {'Filename', 'CII', 'DSM'};

% Export results to CSV
outputCsvPath = 'results.csv';
writetable(resultsTable, outputCsvPath);
fprintf('Results exported to %s\n', outputCsvPath);
