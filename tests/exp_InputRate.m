inputFreqs = [2 7 10:10:60];
meanWeights = [];
outputFreqs = [];

T_sec = 20; % seconds
filename_base = 'exp_inputrate_clus';

enable_metaplasticity = 1;

cd ..;

for inputFreq = inputFreqs
    fprintf('----- RUNNING experiment with input freq %dHz -----\n', inputFreq);
    filename_spec = sprintf('%s-%dHz', filename_base,inputFreq);
    filePath = SingleNeuron_IF_Taivo(T_sec,inputFreq,filename_spec ...
        ,'enable_metaplasticity',enable_metaplasticity);
    
    load(filePath);
    
    % First take average over last 5 sec
    if(size(g_plas_history,2) <= 5)  % if less than 5 sec simulation
        g_plas = mean(g_plas_history, 2);
    else
        g_plas = mean(g_plas_history(:,end-5:end), 2);
    end;
    
    % Take into account ONLY excitatory neurons
    if size(g_plas,1) == 120
        avg = mean(g_plas(1:100));  % 100 exc synapses
    else
        avg = g_plas(1);            % 1 exc synapse
    end;
    
    meanWeights = [meanWeights; avg];
    outputFreqs = [outputFreqs rate_Output5];
    fprintf('----- FINISHED experiment with input freq %dHz: mean weight is %.2f, output freq is %.0fHz  -----\n', inputFreq, avg, rate_Output);
end;

% Write data to file
fileName = sprintf('res_InputRate_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd data_out;
% Save all the relevant stuff

save(fileName, 'inputFreqs', 'outputFreqs', 'meanWeights', 'T0', 'filename_base');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;