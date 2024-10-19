% calculateCII.m

%{
Calculate the Contrast Improvement Index (CII) between original image im1 and
processed image im2
%}

function cii = calculateCII(im1, im2, rect)

    % Isolate ROI from background
    im1Roi = imcrop(im1, rect);
    im2Roi = imcrop(im2, rect);
    [h, w] = size(im1);
    [hRoi, wRoi] = size(im1Roi);

    % Calculate contrast index for original image
    im1RoiMean = mean(im1Roi(:));
    im1BackMean = (mean(im1(:)) * (h*w) - sum(im1Roi(:))) / (h*w - hRoi*wRoi);
    ci1 = (im1RoiMean - im1BackMean) / (im1RoiMean + im1BackMean);

    % Calculate contrast index for processed image
    im2RoiMean = mean(im2Roi(:));
    im2BackMean = (mean(im2(:)) * (h*w) - sum(im2Roi(:))) / (h*w - hRoi*wRoi);
    ci2 = (im2RoiMean - im2BackMean) / (im2RoiMean + im2BackMean);

    % Calculate CII
    cii = ci2 / ci1;
end