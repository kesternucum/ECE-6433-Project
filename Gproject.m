clear; close all; clc;

frequency = 10*10^6; %F = 10GHz
dt = 1/frequency;%Sampling rate
sampling= 0:dt:0.5;
%%Waveform
%sine wave with fixed
A = 1%Amplitude
sin = A * sin(frequency* sampling);
figure(1)
plot(sampling, sin)

%LFM
A = 1%Ampliture
tau = 1;%Pulse durations
t = 0.001;%Pulse width
B = 1/t;%Band width
LFM = A * cos(pi*(B/tau)*(sampling.^2));
figure(2)
plot(sampling, LFM)

%Pulse with fixed wave
frequency = 10*10^9; %F = 10GHz
t = sampling;

pulsewidth = 1e-6;
pulseperiods = [0:10]*4e-6;

x = pulstran(t,pulseperiods,@rectpuls,pulsewidth);
figure(3)
plot(t,x)
axis([0 4e-5 -0.5 1.5])

