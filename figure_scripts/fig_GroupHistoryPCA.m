function [f] = fig_GroupHistoryPCA(g_plas_history)

m1 = mean(g_plas_history(20:29,:), 1);
m2 = mean(g_plas_history(70:79,:), 1);
mo = mean(g_plas_history([1:19 30:69 80:100],:));

f = figure;

plot(m1, 'b');
hold on;
plot(m2, 'r');
plot(mo, 'g');

legend('syn 20:29', 'syn 70:79', 'other syns');

hold off;

end