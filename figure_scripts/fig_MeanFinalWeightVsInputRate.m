function [f] = fig_MeanFinalWeightVsInputRate(inputFreqs, meanWeights)


f = figure();

plot(inputFreqs, meanWeights, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);

xlabel('mean input activity (Hz)');
ylabel('mean final weight');

title('Mean final weight');
