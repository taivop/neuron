function [Omega] = learning_curve(param,Ca)

alfa1 = param.alfa1;      % Learning curve parameters (control LPT and LTF threshold)
beta1 = param.beta1;
alfa2 = param.alfa2;
beta2 = param.beta2;

sig1 = exp(beta1.*(Ca-alfa1))./(1+exp(beta1.*(Ca-alfa1)));
sig2 = exp(beta2.*(Ca-alfa2))./(1+exp(beta2.*(Ca-alfa2)));


if Ca < 4
    Omega = 0.25 + sig2 - 0.25*sig1;
    % incorrect Omega = sig1 - 0.5 .* sig2;
else
    Omega = 1;
end


end