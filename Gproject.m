clear; close all; clc;

frequency = 10*10^3; %F = 10GHz
dt = 1/frequency;%Sampling rate
sampling= 0:dt:0.5;
%%Waveform
%sine wave with fixed
A = 1;%Amplitude
sin = A * sin(frequency* sampling);
figure(1)
plot(sampling, sin)

%LFM
A = 1;%Ampliture
tau = 1;%Pulse durations
t = 0.001;%Pulse width
B = 1/t;%Band width
LFM = A * cos(pi*(B/tau)*(sampling.^2));
figure(2)
plot(sampling, LFM)

%Pulse with fixed wave
t = sampling;
f_p = frequency;
pulsewidth = 50;
sim("pulse")
figure(3)
plot(ans.tout,ans.pulse)

% Generation of Frank Codes
 
PW = 100e-6;% Pulse Width
PCR = 100; % Pulse Compression Ratio
CPW = PW/PCR;% Compressed pulse width
Fm = 2/CPW; %Frequency sweep
 
N = floor(sqrt(PCR));
 
 
steppedFreq = 0:Fm/(N-1):Fm; %stepped frequency approximation to LFM
 
Fs = 8e6; %sampling frequency 4 times Fm assuming bandpass sampling
 
bv = 0:N-1;
 
Matrix = bv'*bv ;
 
incPhi = 360/N; %incremental phase change
 
Matrix = mod(Matrix*incPhi,360);
 
FCP = []; %Frank code
 
t = (0:Fs/(Fm/2)-1)./Fs; %time vector
 
i = 1;
 
for f = steppedFreq
 
    for p = 1:N
 
       FCP = [FCP,exp(1j*(2*pi*f*t + Matrix(i,p)*pi/180))];  
 
    end    
    i = i + 1;
 
end
 
AutoCorrelation = xcorr(FCP);
 
AutoCorrelationdB = 20*log10(abs(AutoCorrelation)/max(abs(AutoCorrelation)));
figure(4)
plot(AutoCorrelationdB)