cd ..;

exp.no = 5;
stateFile = 'exp5/state_to_continue_comparison';
T_sec = 5;

counts_group1 = 0:5:40;
rates_output = [];

%%
for j=1:size(counts_group1, 2)   
    exp.count_group1 = counts_group1(j);
    exp.count_group2 = 100 - exp.count_group1;
    exp.rate_group1 = 40;
    exp.rate_group2 = (1750 - 40 * exp.count_group1) / exp.count_group2;
    
    fileName = SingleNeuron_IF_Taivo(T_sec, 0, 'exp5',...
           'load_state_from_file', stateFile, 'enable_learning', 0, ...
           'experiment', exp);
    
    d = load(fileName);
    rates_output = [rates_output d.rate_Output];
end
%%
% Write data to file
fileName = sprintf('res_exp5_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd exp5/data_out;
% Save all the relevant stuff

save(fileName, 'counts_group1', 'rates_output', 'T_sec', ...
    'stateFile');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;