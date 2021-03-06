cd ..;

exp.no = 4;
T_sec = 5;

counts_group1 = 10:5:50;
rates_output = [];

generating_states = 0;

rates_matrix = [];

for i=1:9
    rates_output = [];
    for j=1:size(counts_group1, 2)   
       exp.count_group1 = counts_group1(j);
       exp.count_group2 = 100 - exp.count_group1;
       exp.rate_group1 = 50 * 20 / exp.count_group1; % total 1000Hz
       exp.rate_group2 = (1750 - exp.count_group1 * exp.rate_group1) / exp.count_group2;

       if generating_states
           % Creating state files to load from
           fprintf('---Creating state file with %d-synapse group 1.\n', exp.count_group1);
           outFileName = sprintf('exp4_state_width%dsyn', exp.count_group1);
           SingleNeuron_IF_Taivo(20, 0, outFileName, 'experiment', exp);
       else
           % Running experiments
           fprintf('---Running experiment with %d-synapse group 1.\n', exp.count_group1);
           stateFile = 'exp4/state_to_continue_comparison';
           fileName = SingleNeuron_IF_Taivo(T_sec, 0, 'exp4',...
               'load_state_from_file', stateFile, 'enable_learning', 0, ...
               'experiment', exp);

           d = load(fileName);

           rates_output = [rates_output d.rate_Output];
       end;
    end
    
    rates_matrix = [rates_matrix; rates_output];
end
%%
% Write data to file
fileName = sprintf('res_exp4_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd exp4/data_out;
% Save all the relevant stuff

save(fileName, 'counts_group1', 'rates_matrix', 'T_sec', ...
    'stateFile');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;