cd('data/');

files = dir('res_*.mat');

% Go through each file, extract params and plot figures
for file = files'
    d = load(file.name);
    
    % Plot figures
    fig_w = fig_MeanFinalWeightVsInputRate(d.inputFreqs, d.meanWeights);
    title(sprintf('Mean final weight vs input rate, EPSP amp=%.1f', d.amp));
    fig_o = fig_OutputRateVsInputRate(d.inputFreqs, d.outputFreqs);
    title(sprintf('Output rate vs input rate, EPSP amp=%.1f', d.amp));
    
    % Save into file
    basedir = '../figures';
    
    filename_w = sprintf('%s/weights_epsp%.1f', basedir, d.amp);
    filename_o = sprintf('%s/iocurve_epsp%.1f', basedir, d.amp);
    
    savefig(fig_w, strcat(filename_w, '.fig'));
    savefig(fig_o, strcat(filename_o, '.fig'));
    
    saveas(fig_w, strcat(filename_w, '.png'), 'png');
    saveas(fig_o, strcat(filename_o, '.png'), 'png');
    
    close(fig_w);
    close(fig_o);
    
end
 