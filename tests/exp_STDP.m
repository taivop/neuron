function [] = exp_STDP(BPAP_index)
    
    BPAP_amplitudes = [42 50 60 70 80 90 100];
    
    filename_base = 'STDP';
    T_sec = 100;

    % "Pairs of presynaptic and postsynaptic stimuli were repeated 100 times at 1 Hz"
    % deltaT is t_post - t_pre
    deltaTvalues = [-100 -50 -30 -10 -5 0 5 10 30 50 75 100 125 150 200];
    meanWeights = [];
    outputFreqs = [];

    cd ..;

    BPAP_amplitude = BPAP_amplitudes(BPAP_index);
    
    for deltaT = deltaTvalues
        fprintf('----- RUNNING experiment with deltaT = %dms -----\n', deltaT);
        filename_spec = sprintf('%s_amp%d_%dms', filename_base, BPAP_amplitude, deltaT);

        fileName = SingleNeuron_IF_Taivo(T_sec, 10, filename_spec, ...
            'STDP_deltaT', deltaT, 'enable_onlyoneinput', 1, ...
            'BPAP_amplitude', BPAP_amplitude, 'enable_inhdrive', 0, ...
            'enable_100x_speedup', 0);
        load(fileName);

        % First take average over last 5 sec
        if(size(g_plas_history,2) <= 5)  % if less than 5 sec simulation
            g_plas = mean(g_plas_history, 2);
        else
            g_plas = mean(g_plas_history(:,end-5:end), 2);
        end;

        % Take into account only the excitatory synapses
        if(size(g_plas,1) == 2)
            avg = mean(g_plas(1));
        else
            avg = mean(g_plas(1:100));
        end;

        meanWeights = [meanWeights; avg];
        outputFreqs = [outputFreqs rate_Output];
    end;


    % Write data to file
    fileName = sprintf('res_STDP_amp%d_%s.mat', BPAP_amplitude, datestr(now,'yyyy-mm-dd_HH-MM-SS'));
    cd data_out;
    % Save all the relevant stuff

    save(fileName, 'deltaTvalues', 'meanWeights', 'outputFreqs', 'T_sec', 'filename_base');
    fprintf('Successfully wrote output to %s\n', fileName);
    cd ../tests;

end