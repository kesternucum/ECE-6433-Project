clear; close all; clc;


c = 3*10^8;%Speed of light

F = rand()*10^7;%Frequency
lambdha = c/F;%Wavelength
tau = rand()*10^-6;%Pulsewidth
B = 1/tau; %Bandwidth
