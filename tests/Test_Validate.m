T_sec = 20;
rate_Input = 40;
filename_spec = 'test_validate';

cd ..;
filePath = ...
    SingleNeuron_IF_Taivo(T_sec, rate_Input, filename_spec);
load(filePath);
cd tests;

plot(Vmat);
