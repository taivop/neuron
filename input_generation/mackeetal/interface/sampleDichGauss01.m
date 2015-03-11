function [s gamma Lambda] = sampleDichGauss01(mu,Sigma,nsamples,already_computed,acc)

% [s gamma rho] = sampleDichGauss01(mu,Sigma,nsamples,already_computed,acc)
%
% 	Draws nsamples samples from a Dichotomized Gaussian distribution with 
%   mean mu and covariance Sigma.
%
%   If you have computed the mean and covariance before, you can plug it in
%   again and set already_computed to true.
%
%		Imporant: s in {0,1}^n, use appropriate covariance matrix and mean.
%		
% 	Usage: S = sampleDichGauss01([.4,.3]',[.24 .1;.1 .21],1000)
%			
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., Neural Computation, 2009
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling

if nargin<=3
    already_computed=0;
end

if nargin<=4
    acc=10^-8;
end

mu=mu(:);

ndim = length(mu);

if already_computed==0
%  [gamma Lambda] = findLatentGaussian(mu,Sigma,acc);
  [gamma Lambda] = findLatentGaussianApprox(mu,Sigma,acc);
else
  gamma = mu;
  Lambda = Sigma;
end

% check whether Lambda is admissable
[R, p] = chol(Lambda);
if p > 0 
  warning(['Covariance matrix of the latent Gaussian has at least one negative eigenvalue. ' ...
            'Applying Higham-Correction (see help higham).'])
  Lambda = higham(Lambda,1e-10,1e5);
  R = chol(Lambda+eye(size(Lambda))*1e-6);
end

% this is a computational bottleneck: takes a lot of memory 
t = R' * randn(ndim,nsamples);

% apply dichotomization
s = (t>repmat(-gamma,1,nsamples));







