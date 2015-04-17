cd ..;

exp.no = 1;

stateFile = 'exp1/state_to_continue_comparison';
T_sec = 5;

rates_group1 = [0 10 17.5 20 30 40 50 60 70];
rates_group2 = (25 * 40 + 75 * 10 - 25 * rates_group1) / 75;
rates_output = [];
% Group2 rate is taken such that total input to neuron remains the same.
% Might be useful to use rates difference (instead of group1 rate) instead.
for j=1:size(rates_group1, 2)
   exp.rate_group1 = rates_group1(j);
   exp.rate_group2 = rates_group2(j);
   
   fileName = SingleNeuron_IF_Taivo(T_sec, 0, 'exp1',...
       'load_state_from_file', stateFile, 'enable_learning', 0, ...
       'experiment', exp);
   
   d = load(fileName);
   
   rates_output = [rates_output d.rate_Output];
   
end
%%
% Write data to file
fileName = sprintf('res_exp1_comparison_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd exp1/data_out;
% Save all the relevant stuff

save(fileName, 'rates_group1', 'rates_group2', 'rates_output', 'T_sec', ...
    'stateFile');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;