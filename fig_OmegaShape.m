function [] = OmegaShape()
calciums = 0:0.01:1
omegas = [];

%SingleNeuron_IF_Taivo_Parameters;

learn_curve.alfa1 = 0.35;      % Learning curve parameters (control LPT and LTF threshold)
learn_curve.beta1 = 80;
learn_curve.alfa2 = 0.55;
learn_curve.beta2 = 80;

for Ca = calciums
    omega = learning_curve(learn_curve,Ca);
    omegas = [omegas; omega];   
end;

figure();
plot(calciums,omegas,'r-');