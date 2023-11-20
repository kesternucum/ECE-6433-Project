% rand_cw_const_sine()
% Produces a random continuous wave (CW) sine waveform
% at a fixed frequency
%
% Arguments:
% n_dc - DC offset for noise
% s_n  - noise variance
% SNR  - desired signal-to-noise ratio (linear)
% A    - amplitude (V)
%
% Returns: 
% y  - waveform with injected noise

function [y] = rand_cw_const_sine (n_dc, s_n, SNR, A)
    f  = randi(390e6) + 10e6;  % Frequency (10 MHz - 400 MHz/VHF and UHF)
	fs = 1e9;  % Sampling frequency, will be consistent (5 GHz)
	N  = randi(6) + 4;         % Number of cycles (5 - 10 cycles)
	y  = cw_const_sine(f, A, fs, N);
    
	[y_i, y_q] = separate_signal_iq_components(y);
	yn = generate_noise(n_dc, s_n, size(y_i), size(y_q));
	y  = inject_noise(y, yn, SNR);
end