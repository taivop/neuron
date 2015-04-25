cd('no_meta/raw/');

files = dir('*.mat');

inputFreqs = [];
outputFreqs = [];
meanWeights = [];

% Go through each file and extract params
for file = files'
    d = load(file.name);
    
    inputFreqs = [inputFreqs d.rate_Input];
    outputFreqs = [outputFreqs d.rate_Output5];
    meanWeights = [meanWeights mean(mean(d.g_plas_history(1:100,end-4:end)))]; % take mean over last 5 seconds
    
end

% These are assumed to be same for each file, so are taken from the last file
enable_metaplasticity = d.parsedParams.enable_metaplasticity;
T0 = d.T0;

% Sorting important data
[inputFreqs, sortIndices] = sort(inputFreqs);
outputFreqs = outputFreqs(sortIndices);
meanWeights = meanWeights(sortIndices);

fileName = '../combined';
save(fileName, 'inputFreqs', 'outputFreqs', 'meanWeights', 'T0', 'enable_metaplasticity');
fprintf('Successfully wrote output to %s\n', fileName);

cd('../..');