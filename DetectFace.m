  function [ output_args ] = DetectFace( Im )
%DETECTFACE Summary of this function goes here
%   Detailed explanation goes here
FaceDetector = vision.CascadeObjectDetector;
%I = imread(input_args);
BB = step(FaceDetector, Im);
IFaces = insertObjectAnnotation(Im, 'rectangle', BB, 'Face');   
figure, imshow(IFaces), title('Detected faces');

%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);
BB=step(MouthDetect,IFaces);
figure,
imshow(IFaces); hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
title('Mouth Detection');
hold off;


%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,IFaces);
figure,imshow(IFaces);
rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');
title('Eyes Detection');

end

