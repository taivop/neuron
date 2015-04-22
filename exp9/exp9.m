cd ..;

exp.no = 9;

stateFile = NaN;%'exp9/state_to_continue';
T_sec = 30;

exp.actual_rates = [];

exp.speedup = 10;
exp.g_plas = [2 1];

%% Build multivariate Gaussian distribution parameters
exp.means = [10 30];                % mean rates
exp.covs = [0.25 0.3; 0.3 1] * 10;  % covariation matrix
%exp.covs = [0.25 0.45; 0.45 1] * 10;  % covariation matrix

%% Run experiment

fileName = SingleNeuron_IF_Taivo(T_sec, 0, 'exp9',...
       'load_state_from_file', stateFile, ...
       'experiment', exp, 'numDendrites', 3, 'endExc', 2, ...
       'enable_inhdrive', 0, 'enable_100x_speedup', 0);

d = load(fileName);

%%
% Write data to file
fileName = sprintf('res_exp9_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd exp9/data_out;
% Save all the relevant stuff

save(fileName, 'd');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;