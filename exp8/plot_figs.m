cd('data/epspamp_0.5');

files = dir('res_*.mat');

% Go through each file, extract params and plot figures
for file = files'
    d = load(file.name);
    
    p = d.exp.p;
    
    % Plot figures
    fig_w = fig_MeanFinalWeightVsInputRate(d.inputFreqs, d.meanWeights);
    title(sprintf('Mean final weight vs input rate, PR p=%.1f', p));
    fig_o = fig_OutputRateVsInputRate(d.inputFreqs, d.outputFreqs);
    title(sprintf('Output rate vs input rate, PR p=%.1f', p));
    
    % Save into file
    basedir = '../../figures2';
    
    filename_w = sprintf('%s/weights_pr%.1f', basedir, p);
    filename_o = sprintf('%s/iocurve_pr%.1f', basedir, p);
    
    savefig(fig_w, strcat(filename_w, '.fig'));
    savefig(fig_o, strcat(filename_o, '.fig'));
    
    saveas(fig_w, strcat(filename_w, '.png'), 'png');
    saveas(fig_o, strcat(filename_o, '.png'), 'png');
    
    close(fig_w);
    close(fig_o);
    
end
 