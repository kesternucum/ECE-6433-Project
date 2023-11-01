% Ex. cw_const_sine(100e9, 10e9, 1e-9)

function [] = cw_const_sine (fs, f, Tmax)
    w  = 2*pi*f;          % Signal frequency (angular), rad/s
    dt = 1/fs;            % Sampling interval
    t  = 0:dt:Tmax;       % Time, s
    A  = 1;               % Amplitude
    y  = A * sin(w*t);    % Signal power
    plot(t, y)
    xlabel('t (s)')
    ylabel('y (W)')
end