% Ex. cw_lfm_chirp(3e5, 10e6, 10e3)

function [] = cw_lfm_chirp (B, fs, PRF)
    waveform = phased.LinearFMWaveform('SweepBandwidth',B,...
        'OutputFormat','Pulses','SampleRate',fs,...
        'PulseWidth',1/PRF,'PRF',PRF,'NumPulses',1);
    wav = step(waveform);
    numpulses = size(wav,1);
    t = [0:(numpulses-1)]/waveform.SampleRate;
    plot(t*1e6,real(wav))
    xlabel('Time (\mu sec)')
    ylabel('Amplitude')
end