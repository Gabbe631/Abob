%ABOB OMR project, Gabriel Berthold & Jonas Kinnvall
clc;
clear all;

%Read image
image1 = imread('images_training/le_1_example.jpg');

%Calls function with image1 as only argumentto return string of notes
strout = tnm034(image1);