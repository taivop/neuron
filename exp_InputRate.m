inputFreqs = [27:2:33];
meanWeights = [];
outputFreqs = [];

T0 = 10000; % ms
filename_base = 'inputrate_100syn';

for inputFreq = inputFreqs
    fprintf('----- RUNNING experiment with input freq %dHz -----\n', inputFreq);
    filename_spec = sprintf('%s-%dHz', filename_base,inputFreq);
    [g_plas, rate_Output] = SingleNeuron_IF_Taivo(T0,inputFreq,filename_spec);
    % Take into account ONLY excitatory neurons
    if size(g_plas,1) == 120
        avg = mean(g_plas(1:100));  % 100 exc synapses
    else
        avg = g_plas(1);            % 1 exc synapse
    end;
    
    meanWeights = [meanWeights; avg];
    outputFreqs = [outputFreqs rate_Output];
    fprintf('----- FINISHED experiment with input freq %dHz: mean weight is %.2f, output freq is %.0fHz  -----\n', inputFreq, avg, rate_Output);
end;

% Write data to file
fileName = sprintf('res_InputRate_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd data_out;
% Save all the relevant stuff

save(fileName, 'inputFreqs', 'outputFreqs', 'meanWeights', 'T0', 'filename_base');
cd ..;