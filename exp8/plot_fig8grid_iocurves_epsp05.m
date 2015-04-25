load('combined_epsp0.5.mat');

f = figure;
set(f, 'units', 'inches', 'pos', [2 2 5.77*2 4.3275])

for i = 1:6
    subplot(2,3,i);
    
    inputs = inputFreqs(i,:);
    outputs = outputFreqs(i,:);
    weights = meanWeights(i,:);
    p = ps(i);
    
    plot(inputs, outputs, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);
    
    axis tight;
    xlim([0, 60]);
    title(sprintf('p=%.1f', p));
    %.1f', p));

    %xlabel('Mean input activity (Hz)');
    %ylabel('Mean output activity (Hz)');

    %title('Mean output activity (Hz)');

    
end;

xlabel(subplot(2,3,5), 'Mean input activity, Hz');
ylabel(subplot(2,3,4), 'Output rate, Hz');
ylabel(subplot(2,3,1), 'Output rate, Hz');

set(0, 'currentfigure', f);  %# for figures
set(f, 'currentaxes', gca);  %# for axes with handle axs on figure f

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 2 5.77*2 4.3275]);

print('../../bscthesis/figures/exp8_gridoutputs_epsp0.5.eps', '-depsc');

%close(f);








