function [] = fig_SpikeRasterPlot(spiketimes)
% Turn spike time matrix into boolean matrix and plot

spiketimes = round(spiketimes);
spikebool = [];

for i=1:size(spiketimes,1)
    
    last = max(spiketimes(i,:));
    row = zeros(1,last);
    row(spiketimes(i,:)) = 1;
    
    spikebool(i,1:size(row,2)) = row;
    
end;

imagesc(spikebool);