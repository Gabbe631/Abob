%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Im= imread('db1_01.jpg');

function id = tnm034(Im) 
% 
% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255] 
% 
% id: The identity number (integer) of the identified person,
% i.e. ?1?, ?2?,...,?16? for the persons belonging to ?db1? 
% and ?0? for all other faces. 
% 
% Your program code. 

for i=1:16
   % Create an image filename, and read it in to a variable called imageData.
	jpgFileName = strcat('db1_0', num2str(i), '.jpg');
	if exist(jpgFileName, 'file')
		imageData = imread(jpgFileName);
	else
		fprintf('File %s does not exist.\n', jpgFileName);
	end 
end

%figure;
%montage(faceDataBase(1).ImageLocation);
%[training, test]=partition(faceDataBase,[0.8 0.2]);

%person = 5;

%[HOGfeatures, viz] = extractHOGFeatures(read(training(person),1));
%figure; 
%subplot(2,2,1); imshow(read(training(person),1));title('input');
%subplot(2,1,2); plot(viz);title('HOG');

DetectFace(Im)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%