for rate=[10 30 50]

    cd ..;

    exp.no = 7;

    T_sec = 5;

    exp.rate = rate;
    weights = [ones(5, 1) * 1; ones(95, 1) * 0.05];
    exp.weights = weights;

    ps = 0:0.2:1;
    num_experiments = 10;

    rates_output = [];

    %% Run experiments

    for i=1:size(ps,2)
        p = ps(i);
        rates_output_thisp = [];
        for j=1:num_experiments
            exp.p = p;

            fileName = SingleNeuron_IF_Taivo(T_sec, 0, ...
                    sprintf('exp7_%dHz_p%.1f', exp.rate, exp.p), ...
                    'enable_learning', 0, ...
                    'enable_VRest_adaptation', 0, ...
                    'experiment', exp);

            d = load(fileName);
            rates_output_thisp = [rates_output_thisp d.rate_Output];
            fprintf('---%d/%d done: ran p=%.1f experiment %d\n',...
                (i-1)*num_experiments + j, size(ps,2)*num_experiments, p, j);
        end;
        rates_output = [rates_output; rates_output_thisp];
    end;

    %% Save data
    % Write data to file
    fileName = sprintf('res_exp7_rate%d_%s.mat', exp.rate, datestr(now,'yyyy-mm-dd_HH-MM-SS'));
    cd exp7/data_out;
    % Save all the relevant stuff
    save(fileName, 'exp', 'ps', 'rates_output', 'num_experiments');
    fprintf('Successfully wrote output to %s\n', fileName);
    cd ..;

end;