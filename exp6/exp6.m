cd ..;

exp.no = 6;

stateFile = 'exp6/state_to_continue';
T_sec = 20;

exp.rate_group1 = 40;
exp.rate_group2 = 10;
exp.rate_noise = 17.5;

%% Run experiment

fileName = SingleNeuron_IF_Taivo(T_sec, 0, 'exp6',...
       'load_state_from_file', stateFile, 'enable_learning', 0, ...
       'experiment', exp);

d = load(fileName);

Vmat = d.Vmat;
spikes_post = d.spikes_post(d.spikes_post > 200000) - 200000; % manually not taking into account training post-spikes
T0 = d.T0;

%% Save data
% Write data to file
fileName = sprintf('res_exp6_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd exp6/data_out;
% Save all the relevant stuff
save(fileName, 'Vmat', 'spikes_post', 'T0', 'T_sec', 'stateFile', 'exp');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;