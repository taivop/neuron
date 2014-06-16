function [eta_val] = eta2002(Ca)

p1 = 0.1;
p2 = p1 * 1e-4; % in article supplementary it incorrectly says division here
p3 = 3;
p4 = 1;

tau = p1./(p2+Ca.^p3) + p4;

%eta_val = 1./tau;
eta_val = 0.5;