inputFreq = 30;
initialWeights = 0.5:0.5:2.5;
finalWeights = [];

for initialWeight = initialWeights
    fprintf('----- RUNNING experiment with initial weight %.2f -----\n', initialWeight);
    g_plas = SingleNeuron_IF_Taivo(inputFreq, initialWeight);
    finalWeights = [finalWeights; g_plas'];
    fprintf('----- FINISHED experiment with initial weight %.2f -----\n', initialWeight);
end;


% Write data to file
fileName = sprintf('res_FinalAndInitialWeights_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd data_out;
% Save all the relevant stuff

save(fileName, 'initialWeights', 'finalWeights');
cd ..;