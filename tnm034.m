function strout = tnm034(im) 
% 
% Im: Inputimage of captured sheet music. Im should be in
% double format, normalized to the interval [0,1] 
% strout: The resulting character string of the detected 
% notes. The string must follow a pre-defined format. 
% 
% OMR Project, Abob, Gabriel Berthold & Jonas Kinnvall

% Makes image grayscale then double
image = im2double(im);

%Binarize image and calculate peak values of binarized image
binIm = 1 - imbinarize(image(:,:,1), 0.7);
h = sum(binIm,2);

[pks, locs] = findpeaks(h);






% figure;
% imshow(binIm)
% figure;
% plot(h, 1:size(h))

end

