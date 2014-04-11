function [] = FigSpiketrainsAndVoltage(InputBool, Vmat, nrExc, nrInh, rate_Input, T0, dt, I0)

%% Plot Figure 1: input spike trains and output voltage
figure();

subplot(2,1,1)
imagesc(InputBool)
title('Input spike trains for the last 1000ms of simulation')
ylabel('Spike train number')
subplot(2,1,2)
plot(Vmat)
title('Postsynaptic neuron voltage')
xlabel('Timebin')
ylabel('Voltage (mV)')

% ONLY FOR MATLAB - doesn't work with Octave
% lowertext = sprintf('%de%di dendrites, %.0fHz input rate, T0=%dms, dt=%.1fms, I0 = %.2f', nrExc, nrInh, rate_Input, T0, dt, I0);
% lowerTextBox = uicontrol('style','text');
% set(lowerTextBox,'String',lowertext);
% set(lowerTextBox,'Units','characters')
% set(lowerTextBox,'HorizontalAlignment','left')
% set(lowerTextBox,'Position',[0 0 length(lowertext) 1])