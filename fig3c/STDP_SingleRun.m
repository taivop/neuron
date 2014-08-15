function [] = STDP_SingleRun(deltaT, filename_base)
T_sec = 100;    % run for how many seconds?

fprintf('----- RUNNING experiment with deltaT = %dms -----\n', deltaT);
filename_spec = sprintf('%s_%dms', filename_base,deltaT);

[g_plas_history, rate_Output] = SingleNeuron_IF_Taivo_STDP(T_sec, deltaT, filename_spec);