function [f] = fig_STDPcurve(deltaTvalues, meanWeights)

f = figure;

plot(deltaTvalues,meanWeights,'k.-','LineWidth',3)
hold on;
plot(deltaTvalues,meanWeights,'kx','MarkerSize',10)
line([min(deltaTvalues) max(deltaTvalues)], [1.25 1.25],'Color', 'k', 'LineStyle', '--');
ylim([min(0.9, min(meanWeights)), Inf]);

xlabel('post-pre deltaT (ms)')
ylabel('mean final weight')
title('(Fig. 3c) STDP curve, 100 second simulation, 1Hz regime')

end