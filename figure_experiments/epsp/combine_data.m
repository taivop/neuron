cd('data/');

files = dir('res_*.mat');

amplitudes = [];
inputFreqs = [];
outputFreqs = [];
meanWeights = [];

% Go through each file and extract params
for file = files'
    d = load(file.name);
    
    [inputFreqsRow, sortIndices] = sort(d.inputFreqs);
    outputFreqsRow = d.outputFreqs(sortIndices);
    meanWeightsRow = d.meanWeights(sortIndices)';
    
    amplitudes = [amplitudes; d.amp];
    inputFreqs = [inputFreqs; inputFreqsRow];
    outputFreqs = [outputFreqs; outputFreqsRow];
    meanWeights = [meanWeights; meanWeightsRow];
    
end

% Sorting important data
[amplitudes, sortIndices] = sort(amplitudes);
inputFreqs = inputFreqs(sortIndices,:);
outputFreqs = outputFreqs(sortIndices,:);
meanWeights = meanWeights(sortIndices,:);


fileName = '../combined.mat';
save(fileName, 'inputFreqs', 'outputFreqs', 'meanWeights', 'amplitudes');
fprintf('Successfully wrote output to %s\n', fileName);

cd('..');