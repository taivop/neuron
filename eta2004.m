function [eta_val] = eta2004(Ca, learn_rate_slope)

eta_val = learn_rate_slope .* Ca;