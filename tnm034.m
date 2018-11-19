function strout = tnm034(image) 
% 
% Im: Inputimage of captured sheet music. Im should be in
% double format, normalized to the interval [0,1] 
% strout: The resulting character string of the detected 
% notes. The string must follow a pre-defined format. 
% 
% OMR Project, Abob, Gabriel Berthold & Jonas Kinnvall
strout = 1;
%Binarize image and calculate peak values of binarized image
binIm = 1- imbinarize(image(:,:,1), 0.6);

h = mean(binIm,2);

%Create threshhold value to filter peaks
peakThresh = mean(h)+ 2* std(h,1);
peakFiltered = (h>peakThresh);

[pks, locs] = findpeaks(double(peakFiltered));


%figure;
%imshow(binIm)
%figure;

%plot(h, 1:size(h))
%figure(); imshow(binIm);
%hold on; 
%for i=1:size(locs,1)
%    plot([1;size(image,2)],[locs(i,1);locs(i,1)],'r');
%end
%hold off;

%Scan binaryImage and remove staffs
for i=1:size(peakFiltered,1)
    
    if(peakFiltered(i,1) == 1)
    binIm(i,:,:)=0;
    end
end
figure;
imshow(binIm);
end

