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
%%%%faceDataBase = imageSet('DB1','recursive');
DetectFace(Im)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%