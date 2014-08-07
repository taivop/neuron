function [] = fig_FinalWeightsVsInputRate(inputFreqs1, meanWeights1, inputFreqs2, meanWeights2, inputFreqs3, meanWeights3)


figure();

plot(inputFreqs1, meanWeights1, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);
hold on;
plot(inputFreqs2, meanWeights2, ...
    'Color','red','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);
plot(inputFreqs3, meanWeights3, ...
    'Color','blue','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);

fprintf('input 1 - black, input 2 - red, input 3 - blue\n');

xlabel('Mean input activity (Hz)');
ylabel('Mean final weight');

title('Fig. 3B: mean final weight curve for different EPSP amplitudes');
