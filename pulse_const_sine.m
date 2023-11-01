% Requires use of the Signal Processing toolbox
% Ex. pulse_const_sine(1, 0.1, 1000, 20, 1)

function [] = pulse_const_sine (prf, pw, fs, f, Tmax)
    T = 0:1/fs:Tmax-1/fs;
    D = 0:1/prf:Tmax-1/prf;
    Y = pulstran(T,D,@(t)sin(2*pi*f*t).*(t>=0).*(t<pw));
    plot(T,Y)
end