

plot(rates_group1, rates_output)
xlabel('Input rate to potentiated group, Hz');
ylabel('Output rate, Hz')
title('Filter implemented by the neuron: the dependence of output rate on the degree of trained input present')
line([17.5 17.5], [35 75], 'LineStyle', '--')