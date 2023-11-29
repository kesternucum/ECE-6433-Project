function helperGenerateTFDfiles_ECE(parentDir,dataDir,wav,truth,Fs,cnntype)

% This function is intended to support ModClassificationOfRadarSignals
% To store the smoothed-pseudo Wigner-Ville distribution of the signals,
% first create the directory TFDDatabase inside your temporary directory
% tempdir. Then create subdirectories in TFDDatabase for each modulation
% type. For each signal, compute the smoothed-pseudo Wigner-Ville
% distribution, and downsample the result to a 227-by-227 matrix. Save the
% matrix as a .png image file in the subdirectory corresponding to the
% modulation type of the signal. 

[~,~,~] = mkdir(fullfile(parentDir,dataDir));
modTypes = unique(truth);

for idxM = 1:length(modTypes)
    modType = modTypes(idxM);
    [~,~,~] = mkdir(fullfile(parentDir,dataDir,char(modType)));
end
    
for idxW = 1:length(truth)
   sig = wav{idxW};
   TFD = wvd(sig,Fs,'smoothedPseudo',kaiser(101,20),kaiser(101,20),'NumFrequencyPoints',500,'NumTimePoints',500);
   if (cnntype == 'squeezenet')
    TFD = imresize(TFD,[227 227]);
   elseif (cnntype == 'resnet18')
    TFD = imresize(TFD,[224 224]);
   end
   TFD = rescale(TFD);
   modType = truth(idxW);
   
   imwrite(TFD,fullfile(parentDir,dataDir,char(modType),sprintf('%d.png',idxW)))
end
end