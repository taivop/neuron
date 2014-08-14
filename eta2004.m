function [eta_val] = eta2004(Ca)
eta_slope = 2e-5;               % #AR2e-5
eta_val = eta_slope .* Ca;