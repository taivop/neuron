cd ..;

exp.no = 3;
exp.rate_input = 10; % Hz

stateFile = 'exp3/state_to_continue_comparison';
T_sec = 30;

correlations = 0:0.1:1;
rates_output = [];
actual_correlations = [];
for j=1:size(correlations, 2)
   exp.correlation = correlations(j);
   fprintf('---Running EXP3 with correlation %.2f.', exp.correlation);
   
   fileName = SingleNeuron_IF_Taivo(T_sec, 0, 'exp3',...
       'load_state_from_file', stateFile, 'enable_learning', 0, ...
       'experiment', exp);
   
   d = load(fileName);
   
   rates_output = [rates_output d.rate_Output];
   actual_correlations = [actual_correlations mean(d.experiment.actual_correlations)];
   
end
%%
% Write data to file
fileName = sprintf('res_exp3_comparison%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd exp3/data_out;
% Save all the relevant stuff

save(fileName, 'correlations', 'rates_output', 'exp', 'T_sec', ...
    'stateFile', 'actual_correlations');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;