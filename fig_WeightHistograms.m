function [] = FigWeightHistograms(gExc, gInh, g_plas0, g_plas, rE, rI)

%% Plot Figure 2: weight histograms
figure();

subplot(2,2,1)
dat = gExc*g_plas0(rE);
m = mean(dat);
hist(dat);
%annotation('textbox', [.16 .82 .1 .1], 'String', sprintf('mean = %.4f', m), 'EdgeColor', 'none', 'BackgroundColor', 'white', 'Margin', 0, 'FaceAlpha', 0);
xlabel('Excitatory initial')

subplot(2,2,2)
dat = gInh*g_plas0(rI);
m = mean(dat);
hist(dat);
%annotation('textbox', [.6 .82 .1 .1], 'String', sprintf('mean = %.4f', m), 'EdgeColor', 'none', 'BackgroundColor', 'white', 'Margin', 0, 'FaceAlpha', 0);
xlabel('Inhibitory initial')

subplot(2,2,3)
dat = gExc*g_plas(rE);
m = mean(dat);
hist(dat);
%annotation('textbox', [.16 .35 .1 .1], 'String', sprintf('mean = %.4f', m), 'EdgeColor', 'none', 'BackgroundColor', 'white', 'Margin', 0, 'FaceAlpha', 0);
xlabel('Excitatory STDP')

subplot(2,2,4)
dat = gInh*g_plas(rI);
m = mean(dat);
hist(dat);
%annotation('textbox', [.6 .35 .1 .1], 'String', sprintf('mean = %.4f', m), 'EdgeColor', 'none', 'BackgroundColor', 'white', 'Margin', 0, 'FaceAlpha', 0);
xlabel('Inhibitory STDP')

% ONLY FOR MATLAB - doesn't work with Octave (also the commented annotations above)
% lowertext = sprintf('%de%di dendrites, %.0fHz input rate, T0=%dms, dt=%.1fms, I0 = %.2f', endExc, nrDendrites-endExc, rate_Input, T0, dt, I0);
% lowerTextBox = uicontrol('style','text');
% set(lowerTextBox,'String',lowertext);
% set(lowerTextBox,'Units','characters')
% set(lowerTextBox,'HorizontalAlignment','left')
% set(lowerTextBox,'Position',[0 0 length(lowertext) 1])