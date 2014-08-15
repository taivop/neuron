
plot(results(:,1),results(:,2)/0.25,'k.-','LineWidth',3)
hold on;
plot(results(:,1),results(:,2)/0.25,'kx','MarkerSize',10)

xlabel('post-pre deltaT (ms)')
ylabel('mean final weight')
title('(Fig. 3c) STDP curve, 100 second simulation, 1Hz regime')

xlim([-160 200])
ylim([0.25 2.5])