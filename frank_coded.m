% Requires use of the Phased Array System toolbox
% Ex. frank_coded(16, 2e-6, 5e3, 2)

function [] = frank_coded(num_chips, chip_width, prf, num_pulses)
    waveform = phased.PhaseCodedWaveform('Code','Frank',...
        'NumChips',num_chips,'ChipWidth',chip_width,...
        'PRF',prf,'OutputFormat','Pulses',...
        'NumPulses',num_pulses);
    wav = step(waveform);
    numpulses = size(wav,1);
    t = [0:(numpulses-1)]/waveform.SampleRate;
    subplot(2,1,1)
    plot(t*1e6,real(wav))
    title('Amplitude')
    xlabel('Time (\mu sec)')
    ylabel('Amplitude')
    
    subplot(2,1,2)
    plot(t*1e6,180/pi*angle(wav))
    title('Phase Angle')
    xlabel('Time (\mu sec)')
    ylabel('Phase Angle (deg)')
end