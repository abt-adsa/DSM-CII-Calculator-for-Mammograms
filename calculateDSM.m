% calculateDSM.m

%{
Calculate the Distsribution Similarity Measure (DSM) between original image
im1 and processed image im2
%}

function dsm = calculateDSM(im1, im2, rect)

    % Convert to double-precision arrays for mean and std operations
    im1 = double(im1);
    im2 = double(im2);

    % Isolate ROI from background
    im1Roi = imcrop(im1, rect);
    im2Roi = imcrop(im2, rect);
    [h, w] = size(im1);

    % Define horizontal and vertical background segments
    horiBackCols = [1:fix(rect(1)) (ceil(rect(1) + rect(3)):w)];
    horiBackRows = 1:h;
    im1HoriBack = im1(horiBackCols, horiBackRows);
    im2HoriBack = im2(horiBackCols, horiBackRows);

    vertBackCols = ceil(rect(1)):fix(rect(1) + rect(3));
    vertBackRows = [1:fix(rect(2)) (ceil(rect(2) + rect(4)):h)];
    im1VertBack = im1(vertBackCols, vertBackRows);
    im2VertBack = im2(vertBackCols, vertBackRows);

    % Calculate distribution statistics for each segment of im1
    im1RoiMean = mean(im1Roi(:));
    im1RoiStd = std(im1Roi(:));
    
    im1HoriBackMean = mean(im1HoriBack(:));
    im1HoriBackStd = std(im1HoriBack(:));
    im1VertBackMean = mean(im1VertBack(:));
    im1VertBackStd = std(im1VertBack(:));

    % Calculate distribution statistics for each segment of im2
    im2RoiMean = mean(im2Roi(:));
    im2RoiStd = std(im2Roi(:));

    im2HoriBackMean = mean(im2HoriBack(:));
    im2HoriBackStd = std(im2HoriBack(:));
    im2VertBackMean = mean(im2VertBack(:));
    im2VertBackStd = std(im2VertBack(:));

    % Calculate DSM
    d1HoriBack = (im1HoriBackMean*im1RoiStd + im1RoiMean*im1HoriBackStd) ...
                /(im1RoiStd + im1HoriBackStd);
    d1VertBack = (im1VertBackMean*im1RoiStd + im1RoiMean*im1VertBackStd) ...
                /(im1RoiStd + im1VertBackStd);

    d2HoriBack = (im2HoriBackMean*im2RoiStd + im2RoiMean*im2HoriBackStd) ...
                /(im2RoiStd + im2HoriBackStd);
    d2VertBack = (im2VertBackMean*im2RoiStd + im2RoiMean*im2VertBackStd) ...
                /(im2RoiStd + im2VertBackStd);

    d1 = (d1HoriBack + d1VertBack)/2;
    d2 = (d2HoriBack + d2VertBack)/2;

    dsm = (abs(d1 - (im2HoriBackMean + im2VertBackMean)/2) ...
         + abs(d2 - im2RoiMean)) ...
         -(abs(d1 - (im1HoriBackMean + im1VertBackMean)/2) ...
         + abs(d2 - im1RoiMean));
end