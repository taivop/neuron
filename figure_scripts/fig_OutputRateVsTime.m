function [] = FigWeightHistograms(spikes_post, rate_Input, T0, dt, I0)

%% Plot Figure 3: Output frequency evolving in time

figure();





% ONLY FOR MATLAB - doesn't work with Octave (also the commented annotations above)
% lowertext = sprintf('%de%di dendrites, %.0fHz input rate, T0=%dms, dt=%.1fms, I0 = %.2f', endExc, nrDendrites-endExc, rate_Input, T0, dt, I0);
% lowerTextBox = uicontrol('style','text');
% set(lowerTextBox,'String',lowertext);
% set(lowerTextBox,'Units','characters')
% set(lowerTextBox,'HorizontalAlignment','left')
% set(lowerTextBox,'Position',[0 0 length(lowertext) 1])