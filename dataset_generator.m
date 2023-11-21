% dataset_generator.m
% Produces waveforms with injected noise
% and adds them to an existing or new structure array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET THESE PARAMETERS
MAX_SNR_DB       = 50;       % Range starts from 0 dB
SNR_DB_INCREMENT = 10;       % Increments
NUM_WAVEFORMS    = 1;        % Will add on to already existing dataset
RUN_STFT         = 1;        % 0 - stores noisy signal, 1 - stores STFT
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

% Sampling Frequency Parameters (consistent across all waveforms)
fs = 1e9;

% SNR Increments
SNR_dB_ratio = floor(MAX_SNR_DB / SNR_DB_INCREMENT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:NUM_WAVEFORMS
    
    % Randomizes Signal-to-Noise Ratio (SNR)
    SNR_dB = (randi(SNR_dB_ratio + 1) - 1) * SNR_DB_INCREMENT;
    SNR = 10^(SNR_dB/10);            % Linear
    A = sqrt(SNR);                   % Amplitude
    
    wf_sel = randi(6);
    switch wf_sel
        case 1
            y = rand_cw_const_sine(n_dc, s_n, SNR, A, fs);
            type = 'CW Const Sine';
        case 2
            y = rand_cw_lfm_chirp(n_dc, s_n, SNR, A, fs);
            type = 'CW LFM Chirp';
        case 3
            y = rand_pulse_const_sine(n_dc, s_n, SNR, A, fs);
            type = 'Const Freq Sine Pulse';
        case 4
            y = rand_pulse_lfm_chirp(n_dc, s_n, SNR, A, fs);
            type = 'LFM Chirp Pulse';
        case 5
            y = rand_frank_coded(n_dc, s_n, SNR, A, fs);
            type = 'Frank Coded Pulse';
        otherwise % case 6
            y = rand_p1_coded(n_dc, s_n, SNR, A, fs);
            type = 'P1 Coded Pulse';
    end
    
    % UNCOMMENT FOR DEBUGGING TO SEE WAVEFORMS
    %plot(real(y))
    fprintf("Waveform %d: %s with SNR = %d dB.\n", index, type, SNR_dB);
    
    if RUN_STFT == 0
        % Store noisy signal
        waveforms(index).signal = y;
    elseif RUN_STFT == 1
        % Store STFT of signal
        
        % The smallest waveform possible is a CW LFM chirp
        % with a PRF of 10 kHz and 2 sweeps recorded at
        % sampling frequency of 1 GHz, which produces 200000 samples.
        % Thus, suitable Gaussian window for this end-case
        % is 2^16, or 65536.
        s = spectrogram(y, gausswin(65536),[],[],fs,'yaxis');
        waveforms(index).signal = s;
    end
    
    waveforms(index).snr    = SNR_dB;
    waveforms(index).type   = type;
    index = index + 1;
end