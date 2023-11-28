% cw_const_sine()
% Produces a continuous wave (CW) sine waveform at a fixed frequency
%
% Arguments:
% f  - waveform frequency (Hz)
% A  - amplitude (V)
% fs - sampling frequency (Hz)
% N  - number of cycles
%
% Returns: 
% y  - waveform voltage amplitude across specified time interval
%
% Ex. cw_const_sine(10e9, 10, 100e9, 5)

function [y] = cw_const_sine (f, A, fs, N)
    w  = 2*pi*f;          % Signal angular frequency (rad/s)
    T  = 1/f;             % Signal period (s)
    Ts = 1/fs;            % Sampling interval (s)
    t  = 0:Ts:N*T;        % Time (s)
    
    % Creates signal vs. time
    y  = A * sin(w*t);    % Signal voltage (V) across time
    
    % Uncomment out to plot waveforms
    % plot(t, y)
    % xlabel('Time (s)')
    % ylabel('Amplitude')
end