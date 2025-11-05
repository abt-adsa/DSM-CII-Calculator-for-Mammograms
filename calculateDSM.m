% calculateDSM.m

%{
Calculate the Distsribution Similarity Measure (DSM) between original image
im1 and processed image im2
%}

function dsm = calculateDSM(im1, im2, rect, background_width)
    % background_width: How many pixels wide the background ring should be.

    % Create a mask for the entire image
    [h, w] = size(im1);
    full_mask = false(h, w);

    % Define the ROI coordinates, ensuring they are integers
    x1 = round(rect(1));
    y1 = round(rect(2));
    x2 = round(rect(1) + rect(3));
    y2 = round(rect(2) + rect(4));

    % Create the ROI mask
    roi_mask = full_mask;
    roi_mask(y1:y2, x1:x2) = true;

    % Create the background mask (the annulus)
    % Define the outer box for the background, clamping to image bounds
    bx1 = max(1, x1 - background_width);
    by1 = max(1, y1 - background_width);
    bx2 = min(w, x2 + background_width);
    by2 = min(h, y2 + background_width);
    
    background_mask = full_mask;
    background_mask(by1:by2, bx1:bx2) = true;
    background_mask(roi_mask) = false; % Exclude the ROI itself from the background

    % Isolate pixels from the original image (im1)
    im1RoiPixels = im1(roi_mask);
    im1BackPixels = im1(background_mask);
    
    % Isolate pixels from the processed image (im2)
    im2RoiPixels = im2(roi_mask);
    im2BackPixels = im2(background_mask);

    % Calculate distribution statistics for im1
    im1RoiMean = mean(im1RoiPixels(:));
    im1RoiStd = std(im1RoiPixels(:));
    im1BackMean = mean(im1BackPixels(:));
    im1BackStd = std(im1BackPixels(:));

    % Calculate distribution statistics for im2
    im2RoiMean = mean(im2RoiPixels(:));
    im2RoiStd = std(im2RoiPixels(:));
    im2BackMean = mean(im2BackPixels(:));
    im2BackStd = std(im2BackPixels(:));

    % Calculate DSM
    d1 = (im1BackMean*im1RoiStd + im1RoiMean*im1BackStd) / (im1RoiStd + im1BackStd);
    d2 = (im2BackMean*im2RoiStd + im2RoiMean*im2BackStd) / (im2RoiStd + im2BackStd);

    dsm = (abs(d1 - im2BackMean) + abs(d2 - im2RoiMean)) - ...
          (abs(d1 - im1BackMean) + abs(d2 - im1RoiMean));