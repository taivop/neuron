
data_in = load('data_out/results4');
d = data_in.d;
rates = d.experiment.actual_rates;

% Weight vector origin
origin = d.experiment.means;

% Take only every 10th g_plas_history measurement (because we sampled 10
% times a sec, but I only want 1 sample a second).
gp1 = mean(d.g_plas_history(1:50, 10:10:end));
gp2 = mean(d.g_plas_history(51:100, 10:10:end));
g_plas_history = [gp1; gp2];

% Start figure
figure;
hold on;

% Plot origin
plot(origin(1), origin(2), 'k+');

% Plot input points
plot(rates(:,1), rates(:,2), 'bo');
axis equal;

% Plot linear regression line
p = polyfit(rates(1:2,1),rates(1:2,2),1);
linreg_x = xlim;
yl = ylim; % save y limits to revert to them later
linreg_y = p(1) * linreg_x + p(2);
linreg_line = plot(linreg_x, linreg_y, 'g-');
ylim(yl);

% Plot weight vector
weight_vec = plot([0, g_plas_history(1,1)] + origin(1), [0, g_plas_history(2,1)] + origin(2), 'r-', 'LineWidth', 2);

legend('Origin', 'Input', 'Regression line', 'Weight vector');

%% Start animation
for i=1:size(rates, 1)    
    datapoint = rates(i,:);
    pause(0.1);
    % Fill datapoint
    plot(datapoint(1), datapoint(2), 'b.', 'MarkerSize', 20);
    
    % Plot weight vector
    delete(weight_vec);
    weight_vec = plot([0, g_plas_history(1,i)] + origin(1), [0, g_plas_history(2,i)] + origin(2), 'r-', 'LineWidth', 2);
    
    % Plot linear regression line
    delete(linreg_line);
    p = polyfit(rates(1:i,1),rates(1:i,2),1);
    linreg_x = xlim;
    yl = ylim; % save y limits to revert to them later
    linreg_y = p(1) * linreg_x + p(2);
    linreg_line = plot(linreg_x, linreg_y, 'g-');
    ylim(yl);
end;










