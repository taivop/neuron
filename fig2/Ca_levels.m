

figure;
hold on;
plot(0.1:0.1:10000, Ca_history);
plot([0 10000],[0.35 0.35],'k--');
plot([0 10000],[0.55 0.55],'k--');
xlabel('Time (ms)');
ylabel('[Ca^{2+}]');
title('Ca levels for deltaT=-50ms');
hold off;