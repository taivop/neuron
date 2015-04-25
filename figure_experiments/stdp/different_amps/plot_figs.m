cd('data/');

files = dir('res_*.mat');

% Go through each file, extract params and plot figures
for file = files'
    d = load(file.name);
    
    % Plot figures
    fig_w = fig_STDPcurve(d.deltaTvalues, d.meanWeights);
    amp = file.name(13:15);
    title(sprintf('STDP curve, 100s simulation, 1Hz regime, BPAP amp=%s', strrep(amp,'_','')));
    
    %chars 13-15
    
    % Save into file
    basedir = '../figures';
    
    filename_w = sprintf('%s/STDPcurve_%s', basedir, amp);
    savefig(fig_w, strcat(filename_w, '.fig'));
    saveas(fig_w, strcat(filename_w, '.png'), 'png');
    close(fig_w);
    
end
 