%ABOB OMR project, Gabriel Berthold & Jonas Kinnvall
clc;
clear;
close all;

%Read image
im = imread('images_training/le_1_example.jpg');
% Makes image grayscale then double
image = im2double(im);
figure;
imshow(image);

%Calls function with image1 as only argumentto return string of notes
strout = tnm034(image);
