% pulse_lfm_chirp()
% Produces a waveform consisting of a series of LFM chirp pulses
% Requires use of the Phased Array System toolbox
%
% Arguments:
% B   - modulation bandwidth (Hz)
% pw  - pulsewidth (s)
% PRF - pulse repetition frequency (Hz) 
% A   - amplitude (V)
% fs  - sampling frequency (Hz)
% N   - number of pulses
%
% Returns: 
% y   - waveform voltage amplitude across specified time interval
%
% Ex. pulse_lfm_chirp(3e5, 50e-6, 10e3, 10, 10e6, 4)

function [y] = pulse_lfm_chirp (B, pw, PRF, A, fs, num_pulses)
    
    % Creates an LFM chirp pulsed waveform with specified parameters
    waveform = phased.LinearFMWaveform(...
        'SweepBandwidth', B,...
        'OutputFormat', 'Pulses',...
        'SampleRate', fs,...
        'PulseWidth', pw,...
        'PRF', PRF,...
        'NumPulses', num_pulses);
    wav_pulses = transpose(step(waveform)) * A;
    
    % Adds listening samples at beginning so pulse does not start a t = 0
    PRI = 1/PRF;   % Pulse repetition interval (s)
    Ts  = 1/fs;    % Sampling interval (s)
    rx_samples_max = (PRI-pw)/Ts;
    num_rx_samples = randi([1 int32(rx_samples_max)], 1, 1);
    wav_rx = zeros(1, num_rx_samples);
    y = [wav_rx wav_pulses];
    
    % Uncomment out to plot waveforms
    % num_samples = size(y,2);
    % t = 0:Ts:(num_samples-1)/fs; % Time (s)
    % plot(t,real(y))
    % xlabel('Time (s)')
    % ylabel('Amplitude')
end