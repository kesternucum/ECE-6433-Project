% 
% ECE 6433 Intro to Radar - Graduate Project
% Spring 2023 - Professor: Dr. Ball
% Team 6 - The Chirps
% Fall 2023
%
% Purpose: 
% Generate a set o radar waveforms with different encoding and SNR, apply 
% the Wigner-Ville distribution
% and use them to train a deep convolutional neural network (CNN).
% This code follows a Matlab-provided example. 
%
% General procedure:
%   - Generate waveforms using a helper function
%   - Note: Does not currently perform Fourier Transform for anything other
%   than plotting to see variances in generated set
%   - Generate smoothed pseudo Wigner-Ville distribution
%   - Setup CNN layers in a pre-trained model to classify 3 modulation types
%   - Choose training options
%   - Train network
%   - Classify performance
%
%------------

close all;
clear al;

usepremade = 0;   % Load a previously generated waveform (name hardcoded)
showfigs = 0;
cnnTypes = categorical(["squeezenet","resnet18","googlenet"]);
cnntouse = 1;  % Change here to select CNN. Move to input param later.
usecnn = cnnTypes(cnntouse);

if usepremade
    load("30waves.mat") %loads modType and wav for 30 signals
    ngensignals = 30;  % Number of signals to generate. 
else
% Generate Radar Waveforms
    rng default
    ngensignals = 10;  % Number of signals to generate. 
    [wav, modType] = wave_generator(ngensignals);
end


if showfigs
    % Plot the Fourier transform for a few of the LFM waveforms to show the
    % variances in the generated set.
    idLFM = find(modType == "LFM",3);
    nfft = 2^nextpow2(length(wav{1}));
    f = (0:(nfft/2-1))/nfft*100e6;

    figure
    subplot(1,3,1)
    Z = fft(wav{idLFM(1)},nfft);
    plot(f/1e6,abs(Z(1:nfft/2)))
    xlabel('Frequency (MHz)');ylabel('Amplitude');axis square
    subplot(1,3,2)
    Z = fft(wav{idLFM(2)},nfft);
    plot(f/1e6,abs(Z(1:nfft/2)))
    xlabel('Frequency (MHz)');ylabel('Amplitude');axis square
    subplot(1,3,3)
    % Z = fft(wav{idLFM(3)},nfft);
    % plot(f/1e6,abs(Z(1:nfft/2)))
    % xlabel('Frequency (MHz)');ylabel('Amplitude');axis square
end



if showfigs
    figure
    title('Wigner-Ville Distribution of original data')
    subplot(1,4,1)
    wvd(wav{find(modType == "ConstSin",1)},100e6,'smoothedPseudo')
    axis square; colorbar off; title('ConstSin')
    subplot(1,4,2)
    wvd(wav{find(modType == "LFM",1)},100e6,'smoothedPseudo')
    axis square; colorbar off; title('LFM')
    subplot(1,4,3)
    wvd(wav{find(modType == "LFMChirp",1)},100e6,'smoothedPseudo')
    axis square; colorbar off; title('LFMChirp')
    subplot(1,4,4)
    wvd(wav{find(modType == "SinPulse",1)},100e6,'smoothedPseudo')
    axis square; colorbar off; title('SinPulse')
end

%%% Feature Extraction Using Wigner Ville Distribution.
% The wvd Matlab function is used to compute the smoothed 
% pseudo WVD for each of the modulation types.to represent a time 
% frequency view of the original signal. This is meant to improve the
% classification performance of machine learning algorithms. The
% increased resolution and locality in time and frequency 
% has been found to bring out features that support the 
% identification of similar modulation types. 

% Then store the result of the Wigner-Ville distribution in a 
% directory called "TFDDatabase" below a tempdir.
% Each modulation will then have its own subdirectory 
% Save the matrix as a .png image file in the appropriate subdirectory. 

% The helper function helperGenerateTFDfiles from the Matlab example
% performs all these steps. 

parentDir = tempdir;
dataDir = 'TFDDatabase';
wvdsamplingrate = 100e6;
helperGenerateTFDfiles_ECE(parentDir,dataDir,wav,modType,wvdsamplingrate, usecnn)


%Create an image datastore object for the created folder to manage the
%image files used for training the deep learning network. This step avoids
%having to load all images into memory. Specify the label source to be
%folder names. This assigns the modulation type of each signal according to
%the folder name.

folders = fullfile(parentDir,dataDir,{'ConstSin','LFM','SinPulse','LFMChirp', 'FC', 'P1'});

imds = imageDatastore(folders,...
    'FileExtensions','.png','LabelSource','foldernames','ReadFcn',@readTFDForSqueezeNet);

%
%Train CNN with 80% of the data, test on it with 10%, validate with 10%
%The splitEachLabel function divides it into these sets.

[imdsTrain,imdsTest,imdsValidation] = splitEachLabel(imds,0.8,0.1);

%
% Set Up Deep Learning Network.
% Before the deep learning network can be
% trained, define the network architecture. 

% Squeezenet accepts image input of size 227-by-227-by-3. 
% Resnet18 accepts image input of size 224-by-224 (-by-3?). 
% Prior to input to the network, the custom read function
% readTFDForSqueezeNet from Matlab example transforms the two-dimensional time-frequency
% distribution to an RGB image of the correct size.  
% Load SqueezeNet.

switch usecnn
    case 'squeezenet'
        net = squeezenet;
    case 'resnet18'
        net = resnet18;
    case 'googlenet'
        net = googlenet;
    otherwise 
        error('CNN not supported.');
end;

%
% Extract the layer graph from the network. Confirm that SqueezeNet is
% configured for images of size 227-by-227-by-3.

lgraphcnn = layerGraph(net);
lgraphcnn.Layers(1)

%if (usecnn == 'squeezenet')
    % To tune SqueezeNet modify three of the last six layers to classify the
    % radar modulation types used.
    % Inspect the last six network layers.
    lgraphcnn.Layers(end-5:end)

    % Replace the drop9 layer, the last dropout layer in the network, with a
    % dropout layer of probability 0.6.
    tmpLayer = lgraphcnn.Layers(end-5);
    newDropoutLayer = dropoutLayer(0.6,'Name','new_dropout');
    lgraphcnn = replaceLayer(lgraphcnn,tmpLayer.Name,newDropoutLayer);

    % Replace the conv10 layer with so that in new layer the number
    % of filters equal to the number of modulation types.
    % Increase the learning rate factors of the new layer.

    numClasses = 6;
    tmpLayer = lgraphcnn.Layers(end-4);
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',20, ...
        'BiasLearnRateFactor',20);
    lgraphcnn = replaceLayer(lgraphcnn,tmpLayer.Name,newLearnableLayer);

    % Replace the classification layer with a new one without class labels.

    tmpLayer = lgraphcnn.Layers(end);
    newClassLayer = classificationLayer('Name','new_classoutput');
    lgraphcnn = replaceLayer(lgraphcnn,tmpLayer.Name,newClassLayer);

    %
    % Inspect the last six layers of the network. Confirm the dropout,
    % convolutional, and output layers have been changed.

    lgraphcnn.Layers(end-5:end)

    %
    % Choose options for the training process that ensures good network
    % performance. Refer to the trainingOptions documentation for a description
    % of each option.

    options = trainingOptions('sgdm', ...
        'MiniBatchSize',128, ...
        'MaxEpochs',5, ...%'MaxEpochs',2, ...
        'InitialLearnRate',1e-3, ...
        'Shuffle','every-epoch', ...
        'Verbose',false, ...
        'Plots','training-progress',...
        'ValidationData',imdsValidation);
%elseif (usecnn == 'resnet18')
%        sprintf('Using resnet18')
%end
%
% Train the Network. 
% This will display a training accuracy plot showing the progress of the
% network's learning across all iterations. 

trainedNet = trainNetwork(imdsTrain,lgraphcnn,options);

%
% Evaluate Performance on Radar Waveforms 
% Generate a confusion matrix to visualize classification performance. Use the

predicted = classify(trainedNet,imdsTest);
figure
title(['CNN: ',char(usecnn), 'Num Signals: ',num2str(ngensignals)] )
confusionchart(imdsTest.Labels,predicted,'Normalization','column-normalized')
title(['CNN: ',char(usecnn), 'Num Signals: ',num2str(ngensignals)] )

%
%---- End of Classification of Radar Signals.

