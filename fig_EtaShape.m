function [] = EtaShape()
calciums = 0:0.01:1;
etas = [];

SingleNeuron_IF_Taivo_Parameters_2002;

for Ca = calciums
    eta = eta2002(Ca);
    etas = [etas; eta];
end;

figure();
plot(calciums,etas,'r-');