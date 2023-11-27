% image_classifier.m
% Implements a linear support vector machine classifier
% to categorize waveform spectrogram images in the dataset folder
% and outputs the covariance result matrix on the test set
% Requires the Computer Vision toolbox

setDir  = "dataset";
imds = imageDatastore("dataset", ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

[trainingSet,testSet] = splitEachLabel(imds,0.8,'randomize');

bag = bagOfFeatures(trainingSet);
categoryClassifier = trainImageCategoryClassifier(trainingSet,bag);
confMatrix = evaluate(categoryClassifier,testSet)
mean(diag(confMatrix))