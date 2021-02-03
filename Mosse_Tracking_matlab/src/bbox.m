function[boundbox,blobCentroid]= bbox(originalImage)
    [rows, columns, numberOfColorChannels] = size(originalImage);
    if numberOfColorChannels > 1
        % Do the conversion using standard book formula
        originalImage = rgb2gray(originalImage);
    end
    se = strel('disk',2);
    originalImage =  imopen(originalImage,se);
    se = strel('disk',8);
    originalImage = imclose(originalImage,se);
    labeledImage = bwlabel(originalImage);
%     coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
%     imshow(coloredLabels);
    blobMeasurements = regionprops(labeledImage, originalImage, 'BoundingBox', 'Area','Centroid');
    numberOfBlobs = size(blobMeasurements, 1);
    maxArea = 0;
   
    for k = 1 : numberOfBlobs           % Loop through all blobs.
        blobArea = blobMeasurements(k).Area;		% Get area.
        if blobArea > maxArea
            maxArea = blobArea;
            boundbox = blobMeasurements(k).BoundingBox;
            blobCentroid = blobMeasurements(k).Centroid;
        end
    % 	blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
                % Get centroid one at a time
    % 	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
    end
%     rectangle('Position',  [boundbox(1),boundbox(2),boundbox(3),boundbox(4)],...
%     'EdgeColor', 'r', 'LineWidth', 2)
end
