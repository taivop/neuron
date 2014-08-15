filename_base = 'STDP';
T_sec = 100;

% "Pairs of presynaptic and postsynaptic stimuli were repeated 100 times at 1 Hz"
% deltaT is t_post - t_pre
deltaTvalues = -160:20:200;
meanWeights = [];
outputFreqs = [];

for deltaT = deltaTvalues
    fprintf('----- RUNNING experiment with deltaT = %dms -----\n', deltaT);
    filename_spec = sprintf('%s_%dms', filename_base,deltaT);
    
    [g_plas_history, rate_Output] = SingleNeuron_IF_Taivo_STDP(T_sec, deltaT, filename_spec);
    
    % First take average over last 5 sec
    if(size(g_plas_history,2) <= 5)  % if less than 5 sec simulation
        g_plas = mean(g_plas_history, 2);
    else
        g_plas = mean(g_plas_history(:,end-5:end), 2);
    end;
    
    % Take into account only the excitatory synapse
    avg = g_plas(1);
    
    meanWeights = [meanWeights; avg];
    outputFreqs = [outputFreqs rate_Output];
end;


% Write data to file
fileName = sprintf('res_STDP_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd data_out;
% Save all the relevant stuff

save(fileName, 'deltaTvalues', 'meanWeights', 'outputFreqs', 'T0', 'filename_base');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;