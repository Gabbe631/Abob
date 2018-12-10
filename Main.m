%ABOB OMR project, Gabriel Berthold & Jonas Kinnvall
clc;
clear;
close all;

%Read image
im = imread('images_training/im1s.jpg');
% Makes image grayscale then double

figure;
imshow(im);

%Calls function with image1 as only argumentto return string of notes
strout = tnm034(im);
