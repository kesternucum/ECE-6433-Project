% rand_frank_coded()
% Produces a random P1-coded waveform
%
% Arguments:
% n_dc - DC offset for noise
% s_n  - noise variance
% SNR  - desired signal-to-noise ratio (linear)
% A  - amplitude (V)
%
% Returns: 
% y  - waveform with injected noise

function [y] = rand_p1_coded (n_dc, s_n, SNR, A)
	num_chips = (randi(4) + 6)^2;  % tB >= 40, so number of chips >= 49
	fs        = 1e9;    % Sampling frequency, will be consistent (1 GHz)

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
end