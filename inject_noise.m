% inject_noise()
% Adds noise into a signal to achieve a specified SNR
%
% Arguments:
% y   - complex signal
% yn  - complex noise signal
% SNR - desired signal-to-noise ratio (SNR)
%
% Returns: 
% y - signal injected with Gaussian noise

function [y] = inject_noise(y, yn, SNR)

    % Force the SNR to desired level
    Psignal = var(y);  % Signal power variance prior forcing SNR
    y = y * sqrt(SNR) / sqrt(Psignal);

    % Uncomment out to see the actual SNR of the signal
    % Pnoise = var(yn);
    % Psignal = var(y);  % Signal power variance after forcing SNR
    % SNR_estimated = 10*log10(Psignal/Pnoise);
    % fprintf("SNR is %.2f dB.\n", SNR_estimated);

    % Add noise to signal
    y = y + yn;

    % Uncomment out to see real component mapped
    % plot(real(y))

end