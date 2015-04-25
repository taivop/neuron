
load('out_groupedinputscorrelated_2015-04-12_18-38-53');

f = figure;
set(f, 'units', 'inches', 'pos', [2 2 5.77*2 4.3275])

%imagesc(g_plas_history(1:100,:));

% Fix x-axis
x=linspace(0,200 * 100/3600,2000);
y=linspace(1,100,100);

imagesc(x,y,g_plas_history(1:100,:));

xlabel('Time, h');
ylabel('Synapse no.');

c = colorbar;
c.Label.String = 'Synaptic weight';

set(gca,'fontsize', 13);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 2 5.77*2 4.3275]);
print('../../../bscthesis/figures/valid_selectivity_correlation.eps', '-depsc');