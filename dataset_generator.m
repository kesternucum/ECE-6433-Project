% dataset_generator.m
% Produces waveforms with injected noise
% and adds them to an existing or new structure array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET THESE PARAMETERS
MAX_SNR_DB       = 50;       % Range starts from 0 dB
SNR_DB_INCREMENT = 10;       % Increments
NUM_WAVEFORMS    = 1;        % Will add on to already existing dataset
RUN_STFT         = 1;        % 0 - stores noisy signal, 1 - stores STFT
TRAINING_DATA    = 1;        % 1 - stores data into category folders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Will store all waveform data in a struct array
% NOTE: Copy over elements in waveform array to differenly named
%       array if running this on a separate dataset
if exist('waveforms', 'var') == 0
    % Will create a new struct array
    index = 1;
else
    % Starts at the next index of pre-existing struct array
    index = numel(waveforms) + 1;
end

% Will store all spectrogram images in folder
if RUN_STFT == 1
    if exist('dataset/cw_const_sine', 'dir') == 0
        % Will create new folder
        mkdir dataset/cw_const_sine
    end
    if exist('dataset/cw_lfm_chirp', 'dir') == 0
        % Will create new folder
        mkdir dataset/cw_lfm_chirp
    end
    if exist('dataset/const_sine_pulse', 'dir') == 0
        % Will create new folder
        mkdir dataset/const_sine_pulse
    end
    if exist('dataset/lfm_chirp_pulse', 'dir') == 0
        % Will create new folder
        mkdir dataset/lfm_chirp_pulse
    end
    if exist('dataset/frank_coded_pulse', 'dir') == 0
        % Will create new folder
        mkdir dataset/frank_coded_pulse
    end
    if exist('dataset/p1_coded_pulse', 'dir') == 0
        % Will create new folder
        mkdir dataset/p1_coded_pulse
    end
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

% STFT Window Parameters
window_size = 65536;
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
            type = 'cw_const_sine';
        case 2
            y = rand_cw_lfm_chirp(n_dc, s_n, SNR, A, fs);
            type = 'cw_lfm_chirp';
        case 3
            y = rand_pulse_const_sine(n_dc, s_n, SNR, A, fs);
            type = 'const_sine_pulse';
        case 4
            y = rand_pulse_lfm_chirp(n_dc, s_n, SNR, A, fs);
            type = 'lfm_chirp_pulse';
        case 5
            y = rand_frank_coded(n_dc, s_n, SNR, A, fs);
            type = 'frank_coded_pulse';
        otherwise % case 6
            y = rand_p1_coded(n_dc, s_n, SNR, A, fs);
            type = 'p1_coded_pulse';
    end
    
    % UNCOMMENT FOR DEBUGGING TO SEE WAVEFORMS
    % plot(real(y))
    fprintf("Waveform %d: %s with SNR = %d dB.\n", index, type, SNR_dB);
    
    if RUN_STFT == 0
        % Store samples of noisy signal in time
        waveforms(index).signal = y;
        waveforms(index).snr    = SNR_dB;
        waveforms(index).type   = type;
        index = index + 1;
    elseif RUN_STFT == 1 && numel(y) > window_size
        % Store name of image of STFT/spectrogram of signal
        
        % The smallest waveform possible is a CW const sine wave
        spectrogram(y, gausswin(window_size),[],[],fs,'yaxis');
        
        image = ['waveform_' num2str(index) '.png'];
        filename = fullfile('dataset', type, image);
        
        saveas(gcf,filename); % Use to display save as image
        waveforms(index).signal = filename;
        waveforms(index).snr    = SNR_dB;
        waveforms(index).type   = type;
        index = index + 1;
    end
end