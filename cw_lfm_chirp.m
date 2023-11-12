% cw_lfm_chirp()
% Produces a linear frequency modulated (LFM) continuous wave chirp
% Requires use of the Phased Array System toolbox
%
% Arguments:
% B   - modulation bandwidth (Hz)
% PRF - pulse repetition frequency (Hz) 
% A   - amplitude (V)
% fs  - sampling frequency (Hz)
% N   - number of sweeps
%
% Returns: 
% y   - waveform voltage amplitude across specified time interval
%
% Ex. cw_lfm_chirp(3e5, 10e3, 10, 10e6, 3)

function [y] = cw_lfm_chirp (B, PRF, A, fs, N)

    PRI = 1/PRF;  % Pulse repetition interval (s)

    % Creates an LFM chirp waveform with specified parameters
    waveform = phased.LinearFMWaveform(...
        'SweepBandwidth', B,...
        'OutputFormat', 'Pulses',...
        'SampleRate', fs,...
        'PulseWidth', PRI,... % Sets sweep to entire PRI
        'PRF', PRF,...
        'NumPulses', N); % 1 pulse for one CW sweep
    y = transpose(step(waveform)) * A;
    
    % Uncomment out to plot waveform
    Ts  = 1/fs;   % Sampling interval (s)
    % num_samples = size(y,2);
    % t = 0:Ts:(num_samples-1)/fs;
    % plot(t,real(y))
    % xlabel('Time (s)')
    % ylabel('Amplitude')
end