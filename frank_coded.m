% frank_coded()
% Produces a Frank phase-coded pulsed waveform
% Requires use of the Phased Array System toolbox
%
% Arguments:
% num_chips  - number of chips
% chip_width - width of each chip (s)
% PRF        - pulse repetition frequency (Hz)
% A          - amplitude (V)
% fs         - sampling rate (Hz)
% N          - number of pulses
%
% Returns: 
% y   - waveform voltage amplitude across specified time interval
%
% Ex. frank_coded(16, 2e-6, 5e3, 10, 1e6, 2)

function [] = frank_coded(num_chips, chip_width, PRF, A, fs, N)
    waveform = phased.PhaseCodedWaveform(...
        'Code', 'Frank',...
        'NumChips', num_chips,...
        'ChipWidth', chip_width,...
        'PRF',  PRF,...
        'OutputFormat', 'Pulses',...
        'SampleRate', fs,...
        'NumPulses', N);
    wav_pulses = transpose(step(waveform)) * A;
    
    % Adds listening samples at beginning so pulse does not start a t = 0
    PRI = 1/PRF;   % Pulse repetition interval (s)
    Ts  = 1/fs;    % Sampling interval (s)
    rx_samples_max = (PRI-num_chips*chip_width)/Ts;
    num_rx_samples = randi([1 int32(rx_samples_max)], 1, 1);
    wav_rx = zeros(1, num_rx_samples);
    y = [wav_rx wav_pulses];
    
    % Uncomment to plot waveforms
    num_samples = size(y,2);
    t = 0:Ts:(num_samples-1)/fs; % Time (s)
    subplot(2,1,1)
    plot(t,real(y))
    title('Amplitude')
    xlabel('Time (s)')
    ylabel('Amplitude')
    
    subplot(2,1,2)
    plot(t, 180/pi*angle(y))
    title('Phase Angle')
    xlabel('Time (s)')
    ylabel('Phase Angle (deg)')
end