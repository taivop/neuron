function [] = fig_MeanFinalWeightVsInputRate(inputFreqs, meanWeights)


figure();

plot(inputFreqs, meanWeights, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);

xlabel('Mean input activity (Hz)');
ylabel('Mean final weight');

title('Mean final weight');
