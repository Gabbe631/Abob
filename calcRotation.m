function [staffAngle] = calcRotation(rotIm)
%Function to calculate rotation of image

[H, theta, rho] = hough(rotIm, 'Theta',-90:0.1:89.9);

peak = houghpeaks(H);

angle = theta(peak(2));

if(angle < 0)
    staffAngle = 270 - angle;
elseif(angle >0)
    staffAngle = 90 - angle;
end

% disp("Rotation angle: " + staffAngle);
end

