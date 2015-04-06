function [f] = fig_OutputRateVsInputRate(inputs, outputs)


f = figure();

plot(inputs, outputs, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);

xlabel('mean input activity (Hz)');
ylabel('mean output activity (Hz)');

title('Mean output activity (Hz)');
