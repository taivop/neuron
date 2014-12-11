%% Auxiliary functions alpha & beta for each gating variable
function gating = makePyrGatingFuns

gating.alphaM_P = @alphaM_P;
gating.betaM_P = @betaM_P;

gating.alphaH_P = @alphaH_P;
gating.betaH_P = @betaH_P;

gating.alphaN_P = @alphaN_P;
gating.betaN_P = @betaN_P;

end

% Pyramidal auxiliary gating functions
function aM_P = alphaM_P(V)
aM_P = (0.32*(V+54)) ./ (-exp(-(V+54)/4) +1);
end

function bM_P = betaM_P(V)
bM_P = (0.28*(V+27)) ./ (exp((V+27)/5) -1);
end

function aH_P = alphaH_P(V)
aH_P = 0.128*exp(-(V+50)/18);
end

function bH_P = betaH_P(V)
bH_P = 4./(exp(-(V+27)/5)+1);
end

function aN_P = alphaN_P(V)
aN_P = (0.032*(V+52)) ./ (-exp(-(V+52)/5) +1);
end

function bN_P = betaN_P(V)
bN_P = 0.5*exp(-(V+57)/40);
end

