%ABOB OMR project, Gabriel Berthold & Jonas Kinnvall
clc;
clear;
close all;

%Read image
image1 = imread('images_training/le_1_example.jpg');
figure;
imshow(image1);
%Calls function with image1 as only argumentto return string of notes
strout = tnm034(image1);
