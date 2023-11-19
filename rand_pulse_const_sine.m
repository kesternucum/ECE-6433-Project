% rand_pulse_const_sine()
% Produces a random constant frequency sine wave chirp pulse
%
% Arguments:
% n_dc - DC offset for noise
% s_n  - noise variance
% SNR  - desired signal-to-noise ratio (linear)
% A  - amplitude (V)
%
% Returns: 
% y  - waveform with injected noise

function [y] = rand_pulse_const_sine (n_dc, s_n, SNR, A)
	f   = randi(390e6) + 10e6; % Frequency (10 MHz - 400 MHz/VHF and UHF)
	fs  = 1e9;  % Sampling frequency, will be consistent (1 GHz)
    
    % Pulsewidth (3 us to 3 ms)
	pw_min_us = 3;               % Minimum pulsewidth (in us)
	pw_max_us = 3000;            % Maximum pulsewidth (in us)
	pw  = (randi(pw_max_us - pw_min_us) + pw_min_us) * 1e-6;
	PRI_min = 10 * pw;           % Pulsewidth <= 0.1 * PRI
	PRI_max = 10 * pw_max_us * 1e-6;
	PRF_min = 1/PRI_max;
	PRF_max = 1/PRI_min;
	 
	% Ensures integer ratio between fs and PRF
	fs_to_PRF_min = floor(fs/PRF_max);
	fs_to_PRF_max = floor(fs/PRF_min);
	PRF = fs / ((randi(fs_to_PRF_max - fs_to_PRF_min) + fs_to_PRF_min));
	N   = randi(3) + 1;            % Number of pulses (2 - 4 pulses)
	y   = pulse_const_sine(f, pw, PRF, A, fs, N);
	
	[y_i, y_q] = separate_signal_iq_components(y);
	yn = generate_noise(n_dc, s_n, size(y_i), size(y_q));
	y  = inject_noise(y, yn, SNR);
end