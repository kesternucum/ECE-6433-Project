% Requires use of the Phased Array System toolbox
% Ex. pulse_lfm_chirp(3e5, 10e6, 50e-6, 10e3, 4)

function [] = pulse_lfm_chirp (B, fs, pw, PRF, num_pulses)
    waveform = phased.LinearFMWaveform('SweepBandwidth',B,...
        'OutputFormat','Pulses','SampleRate',fs,...
        'PulseWidth',pw,'PRF',PRF,'NumPulses',num_pulses);
    wav = step(waveform);
    numpulses = size(wav,1);
    t = [0:(numpulses-1)]/waveform.SampleRate;
    plot(t*1e6,real(wav))
    xlabel('Time (\mu sec)')
    ylabel('Amplitude')
end