function [eta_val] = eta2002(Ca)

p1 = 0.1; 		% #AR0.1
p2 = p1 * 1e-4; % #DI in article supplementary it incorrectly says division here, correct is multiplication.
p3 = 3;			% #AR3
p4 = 1;			% #AR1

tau = p1./(p2+Ca.^p3) + p4; % #AR
eta_val = 1./tau;	% #AR