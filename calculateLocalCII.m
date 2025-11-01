% calculateLocalCII.m
% Calculates CII using a local background annulus around the ROI.

function cii = calculateLocalCII(im1, im2, rect, background_width)
    % background_width: How many pixels wide the background ring should be.
    % A good starting value is 10 or 20.

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

    % Calculate local contrast index for original image
    ci1 = (mean(im1RoiPixels) - mean(im1BackPixels)) / (mean(im1RoiPixels) + mean(im1BackPixels));

    % Calculate local contrast index for processed image
    ci2 = (mean(im2RoiPixels) - mean(im2BackPixels)) / (mean(im2RoiPixels) + mean(im2BackPixels));

    % Calculate CII, handle potential division by zero
    if ci1 ~= 0
        cii = ci2 / ci1;
    else
        cii = Inf; % Or NaN, depending on desired behavior for zero initial contrast
    end
end
