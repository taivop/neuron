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
(spktimes_all<t)&(spktimes_all>0)&(spktimes_all>(t-val))
t_kernel_f_NMDA = t - spktimes_all(:,(spktimes_all<t)&(spktimes_all>0)&(spktimes_all>(t-val)));
f = sum(NMDA.I_f*exp(-t_kernel_f_NMDA./NMDA.tau_f)+NMDA.I_s*exp(-t_kernel_f_NMDA/NMDA.tau_s),2);
I_NMDA = g_NMDA*f*H;


%% Original loop
%           for d0 = 1:numDendrites                                 % NMDA currents for all synapses
%                 %TODO this is very probably the faulty line.
%                t_kernel_f_NMDA = t - spktimes_all(d0,(spktimes_all(d0,:)<t)&(spktimes_all(d0,:)>0)&(spktimes_all(d0,:)>(t-val)));
%                
%                % Implicitly assuming that the 'degree of openness' of all ion channels on a dendrite sum up linearly
%                % Probably should try to simulate saturation?
%                f = sum(NMDA.I_f*exp(-t_kernel_f_NMDA./NMDA.tau_f)+NMDA.I_s*exp(-t_kernel_f_NMDA/NMDA.tau_s));
%                               
%                % NMDA currents
%                %if ~(isempty(f))
%                     I_NMDA(d0) = g_NMDA*f*H;  % f vector inputs, H 1 number
%                     % in article, there is another factor P0 = 0.5, which is the fraction of NMDARs in the closed state that shift to the open state after each presynaptic spike
%                %end
%           end