function [ output_args ] = DetectFace( Im )
%DETECTFACE Summary of this function goes here
%   Detailed explanation goes here
FaceDetector = vision.CascadeObjectDetector;
%I = imread(input_args);
BB = step(FaceDetector, Im);
%IFaces = insertObjectAnnotation(Im, 'rectangle', BB, 'Face');   
%figure, imshow(IFaces), title('Detected faces');

cropImage = imcrop(Im,BB);
a = rgb2gray(cropImage);


a = double(a); %// Cast to double
minvalue = min(a(:)); %// Note the change here
maxvalue = max(a(:)); %// Got rid of superfluous nested min/max calls
normimg = uint8((a-minvalue)*255/(maxvalue-minvalue)); %// Cast back to uint8
[rows, columns, numberOfColorChannels] = size(normimg);



%To detect Eyes, first left eye then right eye
LEyeDetect = vision.CascadeObjectDetector('LeftEye','MergeThreshold', 50);
BB=step(LEyeDetect,normimg);
figure, imshow(normimg); hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
%rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');

REyeDetect = vision.CascadeObjectDetector('RightEye','MergeThreshold', 50);
BB=step(REyeDetect,normimg);
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','g');
end
%rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','g');

%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold', 16);
BB=step(MouthDetect,normimg);
%figure,imshow(IFaces);
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','y');
end

%To detect Nose
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold', 50);
BB=step(NoseDetect,normimg);
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
%rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','y');

hold off;


end

