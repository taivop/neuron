function [f] = OmegaShape()
calciums = 0:0.01:1;
omegas = [];

% learn_curve.alfa1 = 0.35;      % Learning curve parameters (control LPT and LTF threshold)
% learn_curve.beta1 = 80;
% learn_curve.alfa2 = 0.55;
% learn_curve.beta2 = 80;

SingleNeuron_IF_Taivo_Parameters_2004;

for Ca = calciums
    omega = learning_curve2002(learn_curve,Ca);
    omegas = [omegas; omega];   
end;

f = figure();
plot([0 1], [0.25 0.25], 'k--');
hold on;
plot(calciums,omegas,'r-');

title('\Omega')
xlabel('Ca^{2+} (\muM)')
ylabel('\Omega')

xlim([0 1])
ylim([-0.2 1.2])

hold off;