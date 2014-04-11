function [] = fig_WeightHistogramsImpl(g_plas0,g_plas)
SingleNeuron_IF_Taivo_Parameters;

rE = 1:100;
rI = 101:120;


figure();

subplot(2,2,1)
dat = g_plas0(rE);
hist(dat);
xlabel('Excitatory initial')

subplot(2,2,2)
dat = g_plas0(rI);
hist(dat);
xlabel('Inhibitory initial')

subplot(2,2,3)
dat = g_plas(rE);
hist(dat);
xlabel('Excitatory final')

subplot(2,2,4)
dat = g_plas(rI);
hist(dat);
xlabel('Inhibitory final')