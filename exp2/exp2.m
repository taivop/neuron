cd ..;

exp.no = 2;

stateFile = 'exp2/state_to_continue';
T_sec = 5;

exp.rate_group1 = 40;
exp.rate_group2 = 10;

%% Correct bump
exp.swap = 0;

fileName = SingleNeuron_IF_Taivo(T_sec, 0, 'exp2',...
       'load_state_from_file', stateFile, 'enable_learning', 0, ...
       'experiment', exp);

correctBump = load(fileName);

%% Bump in the wrong place
exp.swap = 1;

fileName = SingleNeuron_IF_Taivo(T_sec, 0, 'exp2',...
       'load_state_from_file', stateFile, 'enable_learning', 0, ...
       'experiment', exp);

wrongBump = load(fileName);
   
%% Results
fprintf('Output rate for correct bump %.0fHz, for wrong bump %.0fHz.\n', correctBump.rate_Output, wrongBump.rate_Output);

%%
% Write data to file
fileName = sprintf('res_exp1_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd exp2/data_out;
% Save all the relevant stuff

save(fileName, 'correctBump', 'wrongBump');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;