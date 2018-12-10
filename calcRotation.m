function [staffAngle] = calcRotation(rotIm)
%Function to calculate rotation of image

[H, theta, rho] = hough(rotIm);

peak = houghpeaks(H);

peak

peak(2)

angle = theta(peak(2));

if(angle < 0)
    staffAngle = 90 + theta(peak(2));
elseif(angle >0)
    staffAngle = 90 - theta(peak(2));
end

disp("Rotation angle: " + staffAngle);
end

