function im = readTFDForSqueezeNet(filename)
% This function is only intended to support
% ModClassificationOfRadarAndCommSignalsExample. It may change or be
% removed in a future release.
%Read Image
im = imread(filename);

%Repeat RGB dimension
im = repmat(im,[1 1 3]);