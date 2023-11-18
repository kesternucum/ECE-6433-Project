% dataset_generator.m
% Produces waveforms with injected noise

% Noise Parameters
s_n = 1/sqrt(2);    % Noise variance (V), assume noise variance in
                    % I and Q components are equal, so that
                    % total magnitude variance is 1.
n_dc = 0;           % DC offset of noise (V)

% Amplitude and SNR Parameters
SNR_dB = 10;           % Signal-to-Noise Ratio (dB)
SNR = 10^(SNR_dB/10);  % Signal-to-Noise Ratio (linear)
A = sqrt(SNR);         % Amplitude

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Only comment out one section at a time

%%%%%%%%%%%%%%%%%%%%%%
% Constant Sine Wave %
%%%%%%%%%%%%%%%%%%%%%%
% num_waveforms = 1;         % SET THIS VALUE
% for z = 1:num_waveforms
%     f  = randi(390e6) + 10e6;  % Frequency (10 MHz - 400 MHz/VHF and UHF)
%     fs = 1e9;  % Sampling frequency, will be consistent (5 GHz)
%     N  = randi(6) + 4;         % Number of cycles (5 - 10 cycles)
%     y  = cw_const_sine(f, A, fs, N);
%
%     [y_i, y_q] = separate_signal_iq_components(y);
%     yn = generate_noise(n_dc, s_n, size(y_i), size(y_q));
%     y  = inject_noise(y, yn, SNR);
%     % TODO: Apply STFT
%     % TODO: Add append or export y to a MATLAB object
% end

%%%%%%%%%%%%%
% LFM Chirp %
%%%%%%%%%%%%%
% num_waveforms = 5;              % SET THIS VALUE
% for z = 1:num_waveforms
%     B   = randi(390e6) + 10e6;  % Bandwidth (10 MHz - 400 MHz)
%     fs  = 1e9;  % Sampling frequency, will be consistent (1 GHz)
%
%     % Ensures integer ratio between fs and PRF
%     PRF_min = 100;              % PRF (100 Hz - 10 kHz/Low and Medium)
%     PRF_max = 9900;
%     fs_to_PRF_min = floor(fs/PRF_max);
%     fs_to_PRF_max = floor(fs/PRF_min);
%     PRF = fs / ((randi(fs_to_PRF_max - fs_to_PRF_min) + fs_to_PRF_min));
%     N   = randi(3) + 1;        % Number of sweeps (2 - 4 sweeps)
%     y   = cw_lfm_chirp (B, PRF, A, fs, N);
%
%     [y_i, y_q] = separate_signal_iq_components(y);
%     yn = generate_noise(n_dc, s_n, size(y_i), size(y_q));
%     y  = inject_noise(y, yn, SNR);
%     % TODO: Add append or export y to a MATLAB object
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constant Sine Wave Pulse %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% num_waveforms = 5;             % SET THIS VALUE
% for z = 1:num_waveforms
%     f   = randi(390e6) + 10e6; % Frequency (10 MHz - 400 MHz/VHF and UHF)
%     fs  = 1e9;  % Sampling frequency, will be consistent (1 GHz)
%
%     % Pulsewidth (3 us to 3 ms)
%     pw_min_us = 3;               % Minimum pulsewidth (in us)
%     pw_max_us = 3000;            % Maximum pulsewidth (in us)
%     pw  = (randi(pw_max_us - pw_min_us) + pw_min_us) * 1e-6;
%     PRI_min = 10 * pw;           % Pulsewidth <= 0.1 * PRI
%     PRI_max = 10 * pw_max_us * 1e-6;
%     PRF_min = 1/PRI_max;
%     PRF_max = 1/PRI_min;
%     
%     % Ensures integer ratio between fs and PRF
%     fs_to_PRF_min = floor(fs/PRF_max);
%     fs_to_PRF_max = floor(fs/PRF_min);
%     PRF = fs / ((randi(fs_to_PRF_max - fs_to_PRF_min) + fs_to_PRF_min));
%     N   = randi(3) + 1;            % Number of pulses (2 - 4 pulses)
%     y   = pulse_const_sine(f, pw, PRF, A, fs, N);
%     
%     [y_i, y_q] = separate_signal_iq_components(y);
%      yn = generate_noise(n_dc, s_n, size(y_i), size(y_q));
%      y  = inject_noise(y, yn, SNR);
%      % TODO: Add append or export y to a MATLAB object  
% end

%%%%%%%%%%%%%%%%%%%
% LFM Chirp Pulse %
%%%%%%%%%%%%%%%%%%%
% num_waveforms = 1;              % SET THIS VALUE
% for z = 1:num_waveforms
%     B   = randi(390e6) + 10e6;  % Bandwidth (10 MHz - 400 MHz)
%     fs  = 1e9;  % Sampling frequency, will be consistent (1 GHz)
%
%     % Pulsewidth (3 us to 3 ms)
%     % Note: B = 10 MHz will require at least a pw = 4 us,
%     %       so desired B range matches up with desired pulsewidth range
%     tB_min = 40;                     % Time-Bandwidth product >= 40
%     pw_min_us = ceil(tB_min/B*10e6); % Minimum pulsewidth (in us)
%     pw_max_us = 3000;                % Maximum pulsewidth (in us)
%     pw  = (randi(pw_max_us - pw_min_us) + pw_min_us) * 1e-6;
%     PRI_min = 10 * pw;               % Pulsewidth <= 0.1 * PRI
%     PRI_max = 10 * pw_max_us * 1e-6;
%     PRF_min = 1/PRI_max;
%     PRF_max = 1/PRI_min;
%     
%     % Ensures integer ratio between fs and PRF
%     fs_to_PRF_min = floor(fs/PRF_max);
%     fs_to_PRF_max = floor(fs/PRF_min);
%     PRF = fs / ((randi(fs_to_PRF_max - fs_to_PRF_min) + fs_to_PRF_min));
%     N   = randi(3) + 1;            % Number of pulses (2 - 4 pulses)
%     y   = pulse_lfm_chirp (B, pw, PRF, A, fs, N);
% 
%    [y_i, y_q] = separate_signal_iq_components(y);
%     yn = generate_noise(n_dc, s_n, size(y_i), size(y_q));
%     y  = inject_noise(y, yn, SNR);
%     % TODO: Add append or export y to a MATLAB object
% end

%%%%%%%%%%%%%%%%%%%%%%%%
% Frank Coded Waveform %
%%%%%%%%%%%%%%%%%%%%%%%%
% num_waveforms = 1;                 % SET THIS VALUE
% for z = 1:num_waveforms
%     num_chips = (randi(4) + 6)^2;  % tB >= 40, so number of chips >= 49
%     fs        = 1e9;    % Sampling frequency, will be consistent (1 GHz)
% 
%     tB        = num_chips;         % Time-Bandwidth product
%     pw_min    = 1e-4;              % Pulsewidth (100 us - 1 ms)
%     pw_max    = 1e-3;
%     fs_chip_width_prod_min = floor(fs*(pw_min/num_chips));
%     fs_chip_width_prod_max = floor(fs*(pw_max/num_chips));
%     chip_width = (randi(fs_chip_width_prod_max - fs_chip_width_prod_min)...
%         + fs_chip_width_prod_min) / fs;
%     pw = num_chips * chip_width;
%     
%     % Ensures integer ratio between fs and PRF
%     PRI_min = 10 * pw;       % Pulsewidth <= 0.1 * PRI
%     PRF_min = 100;           % PRF >= 100 Hz
%     PRF_max = 1/PRI_min;
%     fs_to_PRF_min = floor(fs/PRF_max);
%     fs_to_PRF_max = floor(fs/PRF_min);
%     PRF = fs / ((randi(fs_to_PRF_max - fs_to_PRF_min) + fs_to_PRF_min));
%     
%     N   = randi(2) + 2;            % Number of pulses (2 - 4 pulses)
%     y = frank_coded(num_chips, chip_width, PRF, A, fs, N);
%     plot(real(y));
%     [y_i, y_q] = separate_signal_iq_components(y);
%     yn = generate_noise(n_dc, s_n, size(y_i), size(y_q));
%     y  = inject_noise(y, yn, SNR);
%     % TODO: Add append or export y to a MATLAB object
% end

%%%%%%%%%%%%%%%%%%%%%
% P1 Coded Waveform %
%%%%%%%%%%%%%%%%%%%%%
num_waveforms = 1;                 % SET THIS VALUE
for z = 1:num_waveforms
    num_chips = (randi(4) + 6)^2;  % tB >= 40, so number of chips >= 49
    fs        = 1e9;    % Sampling frequency, will be consistent (1 GHz)

    tB        = num_chips;         % Time-Bandwidth product
    pw_min    = 1e-4;              % Pulsewidth (100 us - 1 ms)
    pw_max    = 1e-3;
    fs_chip_width_prod_min = floor(fs*(pw_min/num_chips));
    fs_chip_width_prod_max = floor(fs*(pw_max/num_chips));
    chip_width = (randi(fs_chip_width_prod_max - fs_chip_width_prod_min)...
        + fs_chip_width_prod_min) / fs;
    pw = num_chips * chip_width;
    
    % Ensures integer ratio between fs and PRF
    PRI_min = 10 * pw;       % Pulsewidth <= 0.1 * PRI
    PRF_min = 100;           % PRF >= 100 Hz
    PRF_max = 1/PRI_min;
    fs_to_PRF_min = floor(fs/PRF_max);
    fs_to_PRF_max = floor(fs/PRF_min);
    PRF = fs / ((randi(fs_to_PRF_max - fs_to_PRF_min) + fs_to_PRF_min));
    
    N   = randi(2) + 2;            % Number of pulses (2 - 4 pulses)
    y = p1_coded(num_chips, chip_width, PRF, A, fs, N);
    plot(real(y));
    [y_i, y_q] = separate_signal_iq_components(y);
    yn = generate_noise(n_dc, s_n, size(y_i), size(y_q));
    y  = inject_noise(y, yn, SNR);
    % TODO: Add append or export y to a MATLAB object
end
