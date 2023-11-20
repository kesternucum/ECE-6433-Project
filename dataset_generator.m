% dataset_generator.m
% Produces waveforms with injected noise
% and adds them to an existing or new structure array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET THESE PARAMETERS
MAX_SNR_DB    = 50;  % Range starts from 0 dB
NUM_WAVEFORMS = 1;  % Will add on to already existing dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Will store all waveform data in a struct array
if exist('waveforms', 'var') == 0
    % Will create a new struct array
    index = 1;
else
    % Starts at the next index of pre-existing struct array
    index = numel(waveforms) + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Noise Parameters (consistent across all waveforms)
s_n = 1/sqrt(2);    % Noise variance (V), assume noise variance in
                    % I and Q components are equal, so that
                    % total magnitude variance is 1.
n_dc = 0;           % DC offset of noise (V)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:NUM_WAVEFORMS
    
    % Randomizes Signal-to-Noise Ratio (SNR)
    SNR_dB = randi(MAX_SNR_DB) - 1;
    SNR = 10^(SNR_dB/10);            % Linear
    A = sqrt(SNR);                   % Amplitude
    
    wf_sel = randi(6);
    switch wf_sel
        case 1
            y = rand_cw_const_sine(n_dc, s_n, SNR, A);
            type = 'CW Const Sine';
        case 2
            y = rand_cw_lfm_chirp(n_dc, s_n, SNR, A);
            type = 'CW LFM Chirp';
        case 3
            y = rand_pulse_const_sine(n_dc, s_n, SNR, A);
            type = 'Const Freq Sine Pulse';
        case 4
            y = rand_pulse_lfm_chirp(n_dc, s_n, SNR, A);
            type = 'LFM Chirp Pulse';
        case 5
            y = rand_frank_coded(n_dc, s_n, SNR, A);
            type = 'Frank Coded Pulse';
        otherwise % case 6
            y = rand_p1_coded(n_dc, s_n, SNR, A);
            type = 'P1 Coded Pulse';
    end
    
    waveforms(index).signal = y;
    waveforms(index).snr    = SNR_dB;
    waveforms(index).type   = type;
    index = index + 1;
    
    % UNCOMMENT FOR DEBUGGING TO SEE WAVEFORMS
    % plot(real(y))
    fprintf("%s: SNR is %f dB.\n", type, SNR_dB);
end