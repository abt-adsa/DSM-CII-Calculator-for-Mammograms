% calculateCII.m

%{
Calculate the Contrast Improvement Index (CII) between original image im1 and
processed image im2
%}

function cii = calculateCII(im1, im2, rect)
    
    % Separate foreground and background
    im1Fore = imcrop(im1, rect);
    im2Fore = imcrop(im2, rect);
    [h, w] = size(im1);
    [hFore, wFore] = size(im1Fore);

    % Convert to double-precision arrays for mean operations
    im1 = double(im1);
    im2 = double(im2);

    % Calculate contrast index for original image
    im1ForeMean = mean(im1Fore(:));
    im1BackMean = (mean(im1(:)) * (h*w) - sum(im1Fore(:))) / (h*w - hFore*wFore);
    ci1 = (im1ForeMean - im1BackMean) / (im1ForeMean + im1BackMean);

    % Calculate contrast index for processed image
    im2ForeMean = mean(im2Fore(:));
    im2BackMean = (mean(im2(:)) * (h*w) - sum(im2Fore(:))) / (h*w - hFore*wFore);
    ci2 = (im2ForeMean - im2BackMean) / (im2ForeMean + im2BackMean);

    % Calculate CII
    cii = ci2 / ci1;
end