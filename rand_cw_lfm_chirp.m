% rand_cw_lfm_chirp()
% Produces a random linear frequency modulated (LFM)
% continuous wave chirp
%
% Arguments:
% n_dc - DC offset for noise
% s_n  - noise variance
% SNR  - desired signal-to-noise ratio (linear)
% A  - amplitude (V)
%
% Returns: 
% y  - waveform with injected noise

function [y] = rand_cw_lfm_chirp (n_dc, s_n, SNR, A)
    B   = randi(390e6) + 10e6;  % Bandwidth (10 MHz - 400 MHz)
	fs  = 1e9;  % Sampling frequency, will be consistent (1 GHz)

	% Ensures integer ratio between fs and PRF
	PRF_min = 100;              % PRF (100 Hz - 10 kHz/Low and Medium)
	PRF_max = 9900;
	fs_to_PRF_min = floor(fs/PRF_max);
	fs_to_PRF_max = floor(fs/PRF_min);
	PRF = fs / ((randi(fs_to_PRF_max - fs_to_PRF_min) + fs_to_PRF_min));
	N   = randi(3) + 1;         % Number of sweeps (2 - 4 sweeps)
	y   = cw_lfm_chirp (B, PRF, A, fs, N);
	
	[y_i, y_q] = separate_signal_iq_components(y);
	yn = generate_noise(n_dc, s_n, size(y_i), size(y_q));
	y  = inject_noise(y, yn, SNR);
end