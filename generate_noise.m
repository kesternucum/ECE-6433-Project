% generate_noise()
% Produces a random noise signal
%
% Arguments:
% n_dc - DC offset for noise
% s_n  - noise variance
% y_i_size - size of in-phase component array of signal
% y_q_size - size of quadrature component of signal
%
% Returns: 
% yn   - Gaussian noise signal with length of pure signal

function [yn] = generate_noise(n_dc, s_n, y_i_size, y_q_size)

    yn_i = normrnd(n_dc, s_n, [y_i_size, 1]);
    yn_q = normrnd(n_dc, s_n, [y_q_size, 1]);
    yn = yn_i + 1i * yn_q;

end