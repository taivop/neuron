inputFreqs = [1:2:10 11:3:20];
meanWeights = [];
outputFreqs = [];

initialWeight = 0.25;
T0 = 5000; % ms
filename_base = 'inputrate';

for inputFreq = inputFreqs
    fprintf('----- RUNNING experiment with input freq %dHz -----\n', inputFreq);
    filename_spec = sprintf('%s-%dHz', filename_base,inputFreq);
    [g_plas, rate_Output] = SingleNeuron_IF_Taivo(T0,inputFreq,filename_spec);
    % Take into account ONLY excitatory neurons
    avg = mean(g_plas(rE));
    
    meanWeights = [meanWeights; avg];
    outputFreqs = [outputFreqs rate_Output];
    fprintf('----- FINISHED experiment with input freq %dHz: mean weight is %.2f, output freq is %.0fHz  -----\n', inputFreq, avg, rate_Output);
end;

% Write data to file
fileName = sprintf('res_InputRate_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd data_out;
% Save all the relevant stuff

save(fileName, 'inputFreqs', 'outputFreqs', 'meanWeights', 'initialWeight', 'T0', 'I0');
cd ..;