load('combined.mat');

f = figure;
set(f, 'units', 'inches', 'pos', [2 2 5.77*2 4.3275])

for i = 1:6
    subplot(2,3,i);
    
    inputs = inputFreqs(i,:);
    outputs = outputFreqs(i,:);
    weights = meanWeights(i,:);
    amp = amplitudes(i);
    
    plot(inputs, outputs, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);
    set(gca,'fontsize', 13);
    
    axis tight;
    xlim([0, 60]);
    title(sprintf('%.1fmV', amp));
    
end;

xlabel(subplot(2,3,5), 'Mean input activity, Hz');
ylabel(subplot(2,3,1), 'Output rate, Hz');
ylabel(subplot(2,3,4), 'Output rate, Hz');

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 2 5.77*2 4.3275]);

print('../../../bscthesis/figures/valid_iocurve_vs_epsp_grid.eps', '-depsc');

%close(f);








