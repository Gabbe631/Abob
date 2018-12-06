function strout = tnm034(im) 
% 
% Im: Inputimage of captured sheet music. Im should be in
% double format, normalized to the interval [0,1] 
% strout: The resulting character string of the detected 
% notes. The string must follow a pre-defined format. 
% 
% OMR Project, Abob, Gabriel Berthold & Jonas Kinnvall
strout = 1;

image = im2double(im);

%Binarize image and calculate rotation to rotate image
% CALCULATE ROTATION HERE
%binIm = 1 - imbinarize(image(:,:,1), 0.6);


%Binarize image and calculate peak values of binarized image
BinaryImage = 1 - imbinarize(image(:,:,1), 0.7);

h = mean(BinaryImage,2);

%Create threshhold value to filter peaks
peakThresh = mean(h)+ 2* std(h,1);
peakFiltered = (h>peakThresh);


[pks, locs] = findpeaks(double(peakFiltered));

%Variables to use in main for-loop
[rows,columns] = size(BinaryImage);
nrIm = size(pks,1)/5;
index1 = 1;
index2 = rows/nrIm;

%Main loop to segment image and process each segment individually
for(i=1:nrIm)

binIm = BinaryImage(index1:index2, : );

%figure;
%imshow(binIm);

h2 = mean(binIm,2);

peakThresh2 = mean(h2)+ 2* std(h2,1);
peakFiltered2 = (h2>peakThresh2);

%plot(h, 1:size(h))
%figure(); imshow(binIm);
%hold on; 
%for i=1:size(locs,1)
%    plot([1;size(image,2)],[locs(i,1);locs(i,1)],'r');
%end
%hold off;

%Scan binaryImage and remove staffs where there are no notes intersecting 
for i=1:size(peakFiltered2,1)
    if(peakFiltered2(i,1) == 1 )
        for j=1:columns
            if(binIm(i-1,j,:) == 0)
                binIm(i,j,:)=0;              
            end
        end
    end 
end

%figure;
%imshow(binIm);

%Erosion followed by dilation with disk structure to only show notes
se = strel('disk', 5);
binImNote = imopen(binIm,se);

%Extra erosion to separate notes close to each other
se = strel('disk', 2);
binImNote = imerode(binImNote,se);

%Label all notes and find location of note heads with regionprops
noteLabels = bwlabel(binImNote, 4);

noteHeads = regionprops(noteLabels, 'centroid');
noteCents = cat(1, noteHeads.Centroid);
noteCents;

figure;
imshow(binIm);
hold on;
plot(noteCents(:,1), noteCents(:,2), 'b*');
hold off

%Creating image segment for every note to compare with templates
for i=1:size(noteCents,1)
   
    I = binIm(:,(noteCents(i,1)-10:noteCents(i,1)+25));
    figure;
    imshow(I); 
    
    
end

index1 = ceil(index1 + (rows/nrIm));
index2 = floor(index2 + (rows/nrIm));

end
end

