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

%grayimage = mat2gray(im);
%image = im2double(grayimage);


% Normalize image
image = image - min(image(:));
image = image / max(image(:));

negIm = max(image(:)) - image;
% Plot image
subplot(1,2,1), imshow(image)
subplot(1,2,2), imshow(negIm)


end

