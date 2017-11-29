function [ output_args ] = DetectFace( Im )
%DETECTFACE Summary of this function goes here
%   Detailed explanation goes here
FaceDetector = vision.CascadeObjectDetector;
%I = imread(input_args);
BB = step(FaceDetector, Im);
IFaces = insertObjectAnnotation(Im, 'rectangle', BB, 'Face');   
%figure, imshow(IFaces), title('Detected faces');

%To detect Eyes, first left eye then right eye
LEyeDetect = vision.CascadeObjectDetector('LeftEye','MergeThreshold', 150);
BB=step(LEyeDetect,IFaces);
figure, imshow(IFaces); hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
%rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');

REyeDetect = vision.CascadeObjectDetector('RightEye','MergeThreshold', 175);
BB=step(REyeDetect,IFaces);
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','g');
end
%rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','g');

%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold', 300);
BB=step(MouthDetect,IFaces);
%figure,imshow(IFaces);
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','y');
end

%To detect Nose
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold', 50);
BB=step(NoseDetect,IFaces);
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
%rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','y');

hold off;

end

