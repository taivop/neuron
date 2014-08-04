inputFreqs = 0:1:20;
%inputFreqs = [inputFreqs];
meanWeights = [];
outputFreqs = [];

initialWeight = 0.25;
I0 = 0.15;
T0 = 20000; % ms
filename_base = 'inputrate_onesyn_etaconstant';

for inputFreq = inputFreqs
    fprintf('----- RUNNING experiment with input freq %dHz -----\n', inputFreq);
    filename_spec = sprintf('%s-%dHz', filename_base,inputFreq);
    [g_plas, rate_Output] = SingleNeuron_IF_Taivo(T0,inputFreq,initialWeight,I0,filename_spec);
    % Take into account ONLY excitatory neurons
    if size(g_plas) ~= [1 1]
        avg = mean(g_plas(1:100));
    else
        avg = g_plas;
    end;
    
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