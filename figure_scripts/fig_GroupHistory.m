function [f] = fig_GroupHistory(g_plas_history)

mh = mean(g_plas_history(1:25,:), 1);
ml = mean(g_plas_history(26:100,:), 1);

f = figure;

plot(mh, 'b');
hold on;
plot(ml, 'r');

legend('syn 1:25', 'syn 26:100');

hold off;

end