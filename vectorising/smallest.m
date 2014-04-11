%% All global variables used:
% numDendrites (constant)
% t (constant)
% spktimes_all (matrix: numDendrites x _varying_)
% val (constant)
% NMDA.I_f (constant)
% NMDA.tau_f (constant)
% NMDA.I_s (constant)
% NMDA.tau_s (constant)
% I_NMDA (matrix: numDendrites x 1. This is what we are updating element-wise in the loop right now.)
% g_NMDA (constant)
% H (constant)

%% Local variables:
% d0 (loop var 1:numDendrites)
% t_kernel_f_NMDA (intermediate variable)
% f (unimportant intermediate variable)


          for d0 = 1:numDendrites                                 % NMDA currents for all synapses
                %TODO this is very probably the faulty line.
               t_kernel_f_NMDA = t - spktimes_all(d0,(spktimes_all(d0,:)<t)&(spktimes_all(d0,:)>0)&(spktimes_all(d0,:)>(t-val)));
               
               % Implicitly assuming that the 'degree of openness' of all ion channels on a dendrite sum up linearly
               % Probably should try to simulate saturation?
               f = sum(NMDA.I_f*exp(-t_kernel_f_NMDA./NMDA.tau_f)+NMDA.I_s*exp(-t_kernel_f_NMDA/NMDA.tau_s));
                              
               % NMDA currents
               %if ~(isempty(f))
                    I_NMDA(d0) = g_NMDA*f*H;  % f vector inputs, H 1 number
                    % in article, there is another factor P0 = 0.5, which is the fraction of NMDARs in the closed state that shift to the open state after each presynaptic spike
               %end
          end