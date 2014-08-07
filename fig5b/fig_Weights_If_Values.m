function [] = fig_FinalWeightsVsInputRate(inputFreqs1, meanWeights1, inputFreqs2, meanWeights2, inputFreqs3, meanWeights3)


figure();

plot(inputFreqs1, meanWeights1, ...
    'Color','red','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);
hold on;
plot(inputFreqs2, meanWeights2, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);
plot(inputFreqs3, meanWeights3, ...
    'Color','green','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);

fprintf('input 1 - red (I_f = 0.25), input 2 - black (I_f = 0.5), input 3 - green(I_f = 0.75)\n');

xlabel('Mean input activity (Hz)');
ylabel('Mean final weight');

title('Fig. 5B: mean final weight curve for different I_f values');

legend('I_f = 0.25', 'I_f = 0.5', 'I_f = 0.75');
