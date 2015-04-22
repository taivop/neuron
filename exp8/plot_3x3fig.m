load('combined.mat');

windowcoords = [100, 100, 1000, 900];
f = figure('Position', windowcoords);
set(gca,'OuterPosition',[0.2 0.2 0.8 0.4]);

for i = 1:9
    subplot(3,3,i);
    
    inputs = inputFreqs(i,:);
    outputs = outputFreqs(i,:);
    weights = meanWeights(i,:);
    amp = amplitudes(i);
    
    plot(inputs, weights, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);

    xlim([0, 60]);
    title(sprintf('%.1fmV', amp));

    %xlabel('Mean input activity (Hz)');
    %ylabel('Mean output activity (Hz)');

    %title('Mean output activity (Hz)');

    
end;

xlabel(subplot(3,3,8), 'mean input activity (Hz)');
ylabel(subplot(3,3,4), 'mean final weight');

set(0, 'currentfigure', f);  %# for figures
set(f, 'currentaxes', gca);  %# for axes with handle axs on figure f

savefig(f, '3x3weightcurves.fig');
saveas(f, 'fig_3x3weightcurves.eps', 'eps');

close(f);








