clear; close all; clc;

% LFM param
a =3*10^-6; %Min
b = 3*10^-3;%Max
tau_LFM = (b-a).*rand() + a;

a =10^6; %Min
b = 4*10^8;%Max
B_LFM = (b-a).*rand() + a; %Bandwidth
TB = (B_LFM * tau_LFM); %At least more than 40
F_LFM = 10*10^9;%10GHz

%Sinewave
tau_sin = rand()*10^-4;%Pulsewidth
F_sine = 10^6;%10MHz
timeperiod = 0:1/F_sine:5*10^-3; %Do not exceed more than 10000 row

%Phase
