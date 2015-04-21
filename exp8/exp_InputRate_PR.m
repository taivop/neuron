function [] = exp_InputRate_PR(p_index)

    ps = 0:0.2:1; % index can vary from 1 to 6
    exp.p = ps(p_index);

    inputFreqs = [2 7 10:10:60];
    meanWeights = [];
    outputFreqs = [];

    T_sec = 1; % seconds
    filename_base = sprintf('exp_inputrate_PR-%.1f', exp.p);
    
    cd ..;
    
    exp.no = 8;
    exp.input_correlation = 0.8;

    for inputFreq = inputFreqs
        exp.rate = inputFreq;
        
        fprintf('----- RUNNING experiment with input freq %dHz -----\n', inputFreq);
        filename_spec = sprintf('%s-%dHz', filename_base,inputFreq);
        filePath = SingleNeuron_IF_Taivo(T_sec,inputFreq,filename_spec ...
            ,'experiment', exp);

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
    fileName = sprintf('res_%s_%s.mat', filename_base, datestr(now,'yyyy-mm-dd_HH-MM-SS'));
    cd data_out;
    % Save all the relevant stuff

    save(fileName, 'inputFreqs', 'outputFreqs', 'meanWeights', 'T0', 'filename_base', 'exp');
    fprintf('Successfully wrote output to %s\n', fileName);
    cd ..;

end
