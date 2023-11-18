% separate_signal_iq_components()
% Separates a complex signal into in-phase and quadrature components
%
% Arguments:
% y - complex signal
%
% Returns: 
% y_i - in-phase component array of signal
% y_q - quadrature component of signal

function [y_i, y_q] = separate_signal_iq_components(y)

    y_i = real(y);
    y_q = imag(y);

end