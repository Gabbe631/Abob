Im= imread('DB1/db1_03.jpg');


%faceDataBase.ImageLocation


faceDataBase = imageSet('DB1','recursive');
[training, test]=partition(faceDataBase,[1 1]);


for i=1:1%faceDataBase.Count
%DETECTFACE Summary of this function goes here
%Detailed explanation goes here
Im = read(faceDataBase, i);

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


Image = imresize(normimg, [320 320]);
figure;imshow(Image);

[HOGfeatures, viz] = extractHOGFeatures(Image);
figure; 
subplot(2,2,1); imshow(Image);title('input');
subplot(2,1,2); plot(viz);title('HOG');



end

%figure;
%montage(faceDataBase(1).ImageLocation);
[training, test]=partition(faceDataBase,[0.8 0.2]);

%person = 5;

%[HOGfeatures, viz] = extractHOGFeatures(read(training(person),1));
%figure; 
%subplot(2,2,1); imshow(read(training(person),1));title('input');
%subplot(2,1,2); plot(viz);title('HOG');
