% pulse_const_sine()
% Produces a sine wave pulse with constant frequency
% Requires use of the Signal Processing toolbox
%
% Arguments:
% f   - sine wave frequency (Hz)
% pw  - pulsewidth (s)
% PRF - pulse repetition frequency (Hz) 
% A   - amplitude (in V)
% fs  - sampling frequency (in Hz)
% N   - number of pulses
%
% Returns: 
% y   - waveform voltage amplitude across specified time interval
%
% Ex. pulse_const_sine(20, 0.1, 1, 10, 1000, 4)

function [y] = pulse_const_sine (f, pw, PRF, A, fs, N)
    w  = 2*pi*f;  % Signal angular frequency (rad/s)
    Ts  = 1/fs;   % Sampling interval (s)
    PRI = 1/PRF;  % Pulse repetition interval (s)
    
    % Creates constant sine wave pulsed waveform
    t = 0:Ts:(N*PRI-Ts);   % Time (s)
    d = 0:PRI:(N*PRI-Ts);  % Offset
    wav_pulses = pulstran(t,d,@(t)sin(w*t).*(t>=0).*(t<pw)) * A;
    
    % Adds listening samples at beginning so pulse does not start a t = 0
    Ts = 1/fs;    % Sampling interval (s)
    rx_samples_max = floor((PRI-pw)/Ts);
    num_rx_samples = randi([1 int32(rx_samples_max)], 1, 1);
    wav_rx = zeros(1, num_rx_samples);
    y = [wav_rx wav_pulses];
    
    % Uncomment out to plot waveforms
    % num_samples = size(y,2);
    % t = 0:Ts:(num_samples-1)/fs; % Time (s)
    % plot(t,y)
    % xlabel('Time (s)')
    % ylabel('Amplitude')
end