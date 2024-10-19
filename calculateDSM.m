% calculateDSM.m

%{
Calculate the Distsribution Similarity Measure (DSM) between original image
im1 and processed image im2
%}

function dsm = calculateDSM(im1, im2, rect)

    % Separate foreground and background
    im1Fore = imcrop(im1, rect);
    im2Fore = imcrop(im2, rect);
    [h, w] = size(im1);

    % Convert to double-precision arrays for mean and std operations
    im1 = double(im1);
    im2 = double(im2);

    % Define horizontal and vertical background segments
    horiBackCols = [1:fix(rect(1)) (ceil(rect(1) + rect(3)):w)];
    horiBackRows = 1:h;
    im1HoriBack = im1(horiBackCols, horiBackRows);
    im2HoriBack = im2(horiBackCols, horiBackRows);

    vertBackCols = ceil(rect(1)):fix(rect(1) + rect(3));
    vertBackRows = [1:fix(rect(2)) (ceil(rect(2) + rect(4)):h)];
    im1VertBack = im1(vertBackCols, vertBackRows);
    im2VertBack = im2(vertBackCols, vertBackRows);

    % Calculate distribution statistics for each segment
    im1ForeMean = mean(im1Fore(:));
    im1ForeStd = std(im1Fore(:));

    im1HoriBackMean = mean(im1HoriBack(:));
    im1HoriBackStd = std(im1HoriBack(:));
    im1VertBackMean = mean(im1VertBack(:));
    im1VertBackStd = std(im1VertBack(:));

    im2ForeMean = mean(im2Fore(:));
    im2ForeStd = std(im2Fore(:));

    im2HoriBackMean = mean(im2HoriBack(:));
    im2HoriBackStd = std(im2HoriBack(:));
    im2VertBackMean = mean(im2VertBack(:));
    im2VertBackStd = std(im2VertBack(:));

    % Calculate DSM
    D1HoriBack = (im1HoriBackMean*im1ForeStd + im1ForeMean*im1HoriBackStd) ...
                /(im1ForeStd + im1HoriBackStd);
    D1VertBack = (im1VertBackMean*im1ForeStd + im1ForeMean*im1VertBackStd) ...
                /(im1ForeStd + im1VertBackStd);

    D2HoriBack = (im2HoriBackMean*im2ForeStd + im2ForeMean*im2HoriBackStd) ...
                /(im2ForeStd + im2HoriBackStd);
    D2VertBack = (im2VertBackMean*im2ForeStd + im2ForeMean*im2VertBackStd) ...
                /(im2ForeStd + im2VertBackStd);

    D1 = (D1HoriBack + D1VertBack)/2;
    D2 = (D2HoriBack + D2VertBack)/2;

    dsm = (abs(D1 - (im2HoriBackMean + im2VertBackMean)/2) ...
         + abs(D2 - im2ForeMean)) ...
         -(abs(D1 - (im1HoriBackMean + im1VertBackMean)/2) ...
         + abs(D2 - im1ForeMean));
end