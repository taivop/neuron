inputFreqs = 10:10:20;
inputFreqs = [1 inputFreqs];
outputFreqs = [];

initialWeight = 1.0;
T0 = 20000; %ms

for inputFreq = inputFreqs
    fprintf('----- RUNNING experiment with input freq %dHz -----\n', inputFreq);
    [g_plas, rate_Output] = SingleNeuron_IF_Taivo(T0,inputFreq, initialWeight);
    outputFreqs = [outputFreqs rate_Output];
    fprintf('----- FINISHED experiment with input freq %dHz: output freq is %.0fHz  -----\n', inputFreq, rate_Output);
end;


% Write data to file
fileName = sprintf('res_OutputRateVsInputRate_last5_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd data_out;
% Save all the relevant stuff

save(fileName, 'inputFreqs', 'outputFreqs', 'initialWeight','T0');
cd ..;