% Gproject
% Generates waveforms

clear; close all; clc;

% Sine wave with fixed frequency
f  = 10e9;            % Signal frequency, Hz
T  = 1/f;             % Signal period, s
w  = 2*pi*f;          % Signal frequency (angular), rad/s
dt = 1/(10*f);        % Sampling interval, achieves roughly 10 samples per cycle
t  = 0:dt:(10*T);     % Time, s
A  = 1;               % Amplitude
y  = A * sin(w*t);    % Signal power
%figure(1)
%plot(t, y)
%xlabel('t (s)')
%ylabel('y (W)')

% LFM Continuous-Wave Chirp
% See POMR, 2nd ed., Richards and Melvin, Chapter 19 - Equation 19.50
f   = 10e2;            % Signal frequency, Hz
T   = 1/f;             % Signal period, s 
w   = 2*pi*f;          % Signal frequency (angular), rad/s
dt  = 1/(10*f);        % Sampling rate
t   = 0:dt:0.1;        % Time, s
A   = 1;               % Amplitude
tau = 0.2;             % Pulse duration
B   = 10e3;            % Bandwidth, Hz
y = A * cos(2*pi*f*t + pi*(B/tau)*(t.^2));
figure(2)
plot(t, y)
xlabel('t (s)')
ylabel('y (W)')


%Pulse with fixed wave
prf = 1;
pw = 0.1;
fs = 1000;
f = 20;
T = 0:1/fs:3-1/fs;
D = 0:1/prf:3-1/prf;
Y = pulstran(T,D,@(t)sin(2*pi*f*t).*(t>=0).*(t<pw));
plot(T,Y)


%f  = 10e9;            % Signal frequency, Hz
%T  = 1/f;             % Signal period, s
%w  = 2*pi*f;          % Signal frequency (angular), rad/s
%dt = 1/(10*f);        % Sampling interval, achieves roughly 10 samples per cycle
%t  = 0:1/(10e-6):0.5;       % Samples in time
%A  = 1;               % Amplitude
%y  = A * sin(w*t);    % Signal power

%pw = 1e-6;%(1/10e9)/10;
%pulseperiods = [0:10]*4e-6;
%y = pulstran(t,pulseperiods,@rectpuls,pw);% .* A .* sin(w*t);

%Pulse with fixed wave
%frequency = 10*10^9; %F = 10GHz
%t = sampling;

%pulsewidth = 1e-6;
%pulseperiods = [0:10]*4e-6;

%x = pulstran(t,pulseperiods,@rectpuls,pulsewidth);
%figure(3)
%plot(t,x)
%axis([0 4e-5 -0.5 1.5])

%figure(3)
%plot(t,y)
%axis([0 4e-5 -0.5 1.5])

% LFM Chirp Pulse
%waveform = phased.LinearFMWaveform('SampleRate',1e6,...
%   'PulseWidth',100e-6,'PRF',4e3,...
%    'SweepBandwidth',200e3,'SweepDirection','Up',...
%    'Envelope','Rectangular',...
%    'OutputFormat','Pulses','NumPulses',1);
%figure(4)
%plot(waveform)