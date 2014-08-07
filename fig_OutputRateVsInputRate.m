function [] = fig_OutputRateVsInputRate(inputs, outputs)


figure();

plot(inputs, outputs, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);

xlabel('Mean input activity (Hz)');
ylabel('Mean output activity (Hz)');

title('Mean output activity (Hz)');
