
f = figure;

ps = 0:0.2:1;
for i=1:size(ps, 2)
    p=ps(i);
    
    load(sprintf('data_out/raw/50Hz_p%.1f.mat', p));
    
    subplot(2,3,i);
    histogram(Vmat);
    xlabel('Voltage, mV');
    ylabel('Count');
    title(sprintf('p=%.1f', p));
    
    % show only subthreshold activity
    xlim([-70 -50]);
    
end;

savefig(f, sprintf('figures/voltage_histograms.fig'));
saveas(f, sprintf('figures/voltage_histograms.png'));
close(f);