T_sec = 2;
rate_Input = 5;
filename_spec = 'test_rate_selectivity';

cd ..;
filePath = ...
    SingleNeuron_IF_Taivo(T_sec, rate_Input, filename_spec);
load(filePath);
cd tests;

plot(g_plas);