inputFreqs = 10:10:60;
inputFreqs = [1 inputFreqs];
meanWeights = [];

initialWeight = 1; % This should be kept at 1 during this experiment.
T0 = 20000; % ms
filename_base = 'inputrate';

for inputFreq = inputFreqs
    fprintf('----- RUNNING experiment with input freq %dHz -----\n', inputFreq);
    filename_spec = sprintf('%s-%dHz', filename_base,inputFreq);
    g_plas = SingleNeuron_IF_Taivo(T0,inputFreq,initialWeight,filename_spec);
    % Take into account ONLY excitatory neurons
    avg = mean(g_plas(1:100));
    meanWeights = [meanWeights; avg];
    fprintf('----- FINISHED experiment with input freq %dHz: mean weight is %.2f  -----\n', inputFreq, avg);
end;

% Write data to file
fileName = sprintf('res_MeanFinalWeightVsInputRate_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd data_out;
% Save all the relevant stuff

save(fileName, 'inputFreqs', 'meanWeights', 'initialWeight', 'T0');
cd ..;