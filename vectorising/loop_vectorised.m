function I_NMDA = loop_original(spktimes_all)
%% All global variables used:
numDendrites = 120;% (constant)
t = 10001;% (constant)
% spktimes_all (matrix: numDendrites x _varying_)
val = 12500; % (constant)
NMDA.I_f = 70; %(constant)
NMDA.tau_f = 50; % (constant)
NMDA.I_s = 30; % (constant)
NMDA.tau_s = 200;% (constant)
% I_NMDA (matrix: numDendrites x 1. This is what we are updating element-wise in the loop right now, i.e. the result.)
g_NMDA = 0.0045; % (constant)
H = 0.0531; % (constant)


%% Local variables:
% d0 (loop var 1:numDendrites)
% t_kernel_f_NMDA (intermediate variable)
% f (unimportant intermediate variable)
        
%% Vectorised
%ind2sub, sub2ind, [row,col]=find(a>0&a<8) või a(a>0&a<8)
% find the indices of suitable spiketimes
%[I,J] = find(spktimes_all>0 & spktimes_all<t & spktimes_all>(t-val));
%t_kernel_f_NMDA = t - spktimes_all(:,(spktimes_all<t)&(spktimes_all>0)&(spktimes_all>(t-val)));
t_kernel_f_NMDA = (t - spktimes_all) .* (spktimes_all>0 & spktimes_all<t & spktimes_all>(t-val));
tauf = -t_kernel_f_NMDA./NMDA.tau_f;
taus = -t_kernel_f_NMDA./NMDA.tau_s;
tauf(tauf==0) = -Inf;
taus(taus==0) = -Inf;
f = sum(NMDA.I_f*exp(tauf)+NMDA.I_s*exp(taus),2);
I_NMDA = g_NMDA*f*H;
%fprintf('size of vectorised I_NMDA is %dx%d\n',size(I_NMDA,1),size(I_NMDA,2));
