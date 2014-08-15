function [] = EtaShape()
calciums = 0:0.01:1;
etas = [];

SingleNeuron_IF_Taivo_Parameters_2004;

for Ca = calciums
    %eta = eta2004(Ca);
    eta = eta2002(Ca);
    etas = [etas; eta];
end;

figure();
plot(calciums,etas,'r-');

title('\eta');
xlabel('Ca^{2+} (\muM)');
ylabel('\eta (sec^{-1})');
xlim([0 1])
ylim([-0.2 1.2])