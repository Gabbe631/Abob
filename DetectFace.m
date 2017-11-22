function [ output_args ] = DetectFace( input_args )
%DETECTFACE Summary of this function goes here
%   Detailed explanation goes here
detector = vision.CascadeObjectDetector;
I = imread(input_args);
bboxes = step(detector, I);
IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');   
figure, imshow(IFaces), title('Detected faces');

end

