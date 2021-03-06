cd ..;

exp.no = 10;

stateFile = NaN;%'exp10/state_to_continue';
T_sec = 60;

exp.actual_rates = [];

exp.speedup = 100;
exp.g_plas = ones(100, 1);%[ones(50,1) * 2; ones(50,1) * 1];

exp.correlation1 = 0.5;
exp.correlation2 = 0.5;

%% Build multivariate Gaussian distribution parameters
%exp.means = [10 30];                % mean rates
%exp.covs = [0.25 0.3; 0.3 1] * 10;  % covariation matrix

exp.means = [10 10];                % mean rates
exp.covs = [1 0.1; 0.1 0.05] * 10;  % covariation matrix

%% Run experiment

fileName = SingleNeuron_IF_Taivo(T_sec, 0, 'exp10',...
       'load_state_from_file', stateFile, ...
       'experiment', exp, ...
       'enable_100x_speedup', 0, ...
       'enable_VRest_adaptation', 0, ...
       'EPSP_amplitude', 0.5, ...
       'BPAP_amplitude', 100);

d = load(fileName);

%%
% Write data to file
fileName = sprintf('res_exp10_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
cd exp10/data_out;
% Save all the relevant stuff

save(fileName, 'd');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;