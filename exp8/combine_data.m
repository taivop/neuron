cd('data/');

files = dir('res_*.mat');

ps = [];
inputFreqs = [];
outputFreqs = [];
meanWeights = [];

% Go through each file and extract params
for file = files'
    d = load(file.name);
    
    [inputFreqsRow, sortIndices] = sort(d.inputFreqs);
    outputFreqsRow = d.outputFreqs(sortIndices);
    meanWeightsRow = d.meanWeights(sortIndices)';
    
    ps = [ps; d.exp.p];
    inputFreqs = [inputFreqs; inputFreqsRow];
    outputFreqs = [outputFreqs; outputFreqsRow];
    meanWeights = [meanWeights; meanWeightsRow];
    
end

% Sorting important data
[ps, sortIndices] = sort(ps);
inputFreqs = inputFreqs(sortIndices,:);
outputFreqs = outputFreqs(sortIndices,:);
meanWeights = meanWeights(sortIndices,:);


fileName = '../combined.mat';
save(fileName, 'inputFreqs', 'outputFreqs', 'meanWeights', 'amplitudes');
fprintf('Successfully wrote output to %s\n', fileName);

cd('..');