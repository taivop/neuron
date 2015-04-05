function [f] = fig_VoltageAndSpikesVsTime(Vmat, spikes_post)

f = figure;
hold on;

y=[-100,40];

for spike=spikes_post
    x=[spike,spike];
    plot(x,y,'r-');
end;

plot(Vmat,'b-');

hold off;