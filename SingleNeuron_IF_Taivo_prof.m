T0 = 1000;
rate_Input = 30;
initialWeight = 1;

%% Script initialization
simulationStartTime = clock;

% Load parameters
SingleNeuron_IF_Taivo_Parameters;

%% PAR: Set simulation parameters
trial_id = 1;                   % Trial identifier
%T0 = 1000;                      % Simulation time (ms), MUST BE MULTIPLE OF 1000ms
dt = 0.1;                       % Simulating Time step (ms)
tw = 0.5;                       % Writing time step (ms)
Tsim = T0/dt;                   % num of time steps
enableMetaplasticity = 1;       % enable metaplasticity?
enableInhplasticity = 0;        % enable inhibitory plasticity?

I0 = 0.15;                      % Basal drive to pyramidal neurons (controls basal rate; 1.5 -> gamma freq (about 40-50 Hz) when isolated)
fprintf('I0 = %.2f\n', I0);

% Synaptic conductivities
g_PP = 0.017;                    % Maximal synaptic conductivity (AMPA) on pyramidal neurons
g_IP = 0.1;                     % Maximal synaptic conductivity (GABA) on pyramidal neurons
% Inhibitory conductivity (g_IP) should range in 2x...20x excitatory conductivity (g_PP)

% Input trains and # of dendrites
%rate_Input = 15; % Hz
numDendrites = 120;
endExc = 100;                    % Last excitatory synapse
startInh = endExc + 1;          % First inhibitory synapse
rE = 1:endExc;                  % Excitatory synapses
rI = startInh:numDendrites;      % Inhibitory synapses

% Dividing the simulation time into one-second bins
numBins = T0 / 1000;


%% Generate initial input spikes
% desiredCorrelation = 0;
% 
% [spikes_binary, spiketimes] = GenerateInputSpikes(endExc, rate_Input, desiredCorrelation, T0, dt, 0);
% [spikes_binary2, spiketimes2] = GenerateInputSpikes(numDendrites-endExc, rate_Input, 0, T0, dt, 0);
% 
% InputBool = [spikes_binary;spikes_binary2];
% spktimes =  zeros(numDendrites,max(size(spiketimes,2),size(spiketimes2,2)));
% spktimes(1:endExc,1:size(spiketimes,2)) = spiketimes;
% spktimes(startInh:numDendrites,1:size(spiketimes2,2)) = spiketimes2;
% 
%% Neurotransmitter concentrations from presynaptic spikes
% 
% V_Input = InputBool*100-70;
% 
% s = zeros(size(InputBool));  % plays as external input drive 
% for t=2: Tsim   
%     s(rE,t) = s(rE,t-1) + dt*(((1+tanh(V_Input(rE,t)/10))/2).*(1-s(rE,t-1))/tau_R_E -s(rE,t-1)/tau_D_E);   % neurotransmitter concentration at the synapse
%     s(rI,t) = s(rI,t-1) + dt*(((1+tanh(V_Input(rI,t)/10))/2).*(1-s(rI,t-1))/tau_R_I -s(rI,t-1)/tau_D_I);   % neurotransmitter concentration at the synapse
% end

%% Initializations
%I0 = 0;                            % Make empty matrices to hold basal current values
V = -60.0 + 10*rand(1);             % Initial postsynaptic voltage

% Some parameters to describe how open the gates are
myPyrGatingFuns = makePyrGatingFuns;
aM = myPyrGatingFuns.alphaM_P(V);
bM = myPyrGatingFuns.betaM_P(V);
aH = myPyrGatingFuns.alphaH_P(V);
bH = myPyrGatingFuns.betaH_P(V);
aN = myPyrGatingFuns.alphaN_P(V);
bN = myPyrGatingFuns.betaN_P(V);

m = aM./(aM+bM);
h = aH./(aH+bH);
n = aN./(aN+bN);


% g_plas are the coefficients we use to get conductivities from their base values.
% They are named 'w' in the article.
g_plas = ones(numDendrites,1) .* initialWeight;                   % Array with all synaptic weights (evolves during plasticity)

g_plas0 = g_plas;                               % Save initial values for plotting later.
Ca = zeros(numDendrites,1);                      % Array for calcium concentration in dendrites
g_NMDA = stab.gt;                               % Initialize NMDA channel conductivity to stable point.
%TODO try to divide by 4

Ca_history = [];
g_plas_history = [];

% Initialisations for some loop internal variables
oldV    = V-(V_sp_thres);
spikes_post=[];                                 % Output spike times
spikes_last5sec = [];
Vmat    = zeros (1,Tsim);                       % Voltage of postsynaptic neuron
spktimes_all = [];

% Time window to check in the past for release of neurotransmitter
val=5*(NMDA.tau_f+NMDA.tau_s)/dt;
%fprintf('The value of the variable val=%.3f',val);

% Set maximal conductivities for inh and exc synapses
gInh = g_IP;
gExc = g_PP;

%% MAIN LOOP

disp('Running main loop...');
waitbar(0);
for t=1: Tsim                       % Loop over time
    largebin = fix((t-1)/10000);     % STARTS FROM ZERO. find out which large time bin we are in
    t_inner = mod(t,10000);          % find out where we are in the current large time bin
    if t_inner == 0
        t_inner = 10000;
    end;
    
    %TODO CHANGE: if (mod(t,    20000)==1)
    if (mod(t,10000)==1)
        fprintf('t = %5dms\n',largebin * 1000 + t_inner);
        g_plas_history = [g_plas_history g_plas];
        
%         % Preserve previous spike times, if exist
%         if largebin >= 1
%             spktimes_all = [spktimes_all (spktimes + 1000 * largebin)];  % take into account time shift 1000ms per large time bin passed
%             % TODO: can we do that? Some synapses are padded on the right
%             % with zeros, maybe should take that into account?
%             % Yeah, we probably can.
%         end;
        
        % Generate input spikes
        desiredCorrelation = 0; % desired correlation for input to excitatory synapses

        [spikes_binary, spiketimes] = GenerateInputSpikes(endExc, rate_Input, desiredCorrelation, 1000, dt, 0);
        [spikes_binary2, spiketimes2] = GenerateInputSpikes(numDendrites-endExc, rate_Input, 0, 1000, dt, 0);

        InputBool = [spikes_binary;spikes_binary2];
        spktimes =  zeros(numDendrites,max(size(spiketimes,2),size(spiketimes2,2)));
        spktimes(1:endExc,1:size(spiketimes,2)) = spiketimes;
        spktimes(startInh:numDendrites,1:size(spiketimes2,2)) = spiketimes2;
                     
        if largebin == 0
            spktimes_all = spktimes;
        else
            spktimes_all = [spktimes_all (spktimes + 10000 * largebin)];
        end;
        %-- input spikes generated
        
        % Get neurotransmitter concentrations from presynaptic spikes
        V_Input = InputBool*100-70;
        
        if largebin==0              % if we are starting the simulation, set to zero
            s_lastE = 0;
            s_lastI = 0;
        else
            s_lastE = s(rE,1000);   % if already simulating, use value from previous timebin
            s_lastI = s(rI,1000);
        end;
        
        s = zeros(size(InputBool));  % plays as external input drive 
        
        s(rE,1) = s_lastE + dt*(((1+tanh(V_Input(rE,1)/10))/2).*(1-s_lastE)/tau_R_E -s_lastE/tau_D_E);
        s(rI,1) = s_lastI + dt*(((1+tanh(V_Input(rI,1)/10))/2).*(1-s_lastI)/tau_R_I -s_lastI/tau_D_I);
        
        for t2=2:10000  
            s(rE,t2) = s(rE,t2-1) + dt*(((1+tanh(V_Input(rE,t2)/10))/2).*(1-s(rE,t2-1))/tau_R_E -s(rE,t2-1)/tau_D_E);   % neurotransmitter concentration at the synapse
            s(rI,t2) = s(rI,t2-1) + dt*(((1+tanh(V_Input(rI,t2)/10))/2).*(1-s(rI,t2-1))/tau_R_I -s(rI,t2-1)/tau_D_I);   % neurotransmitter concentration at the synapse
        end
        
        %-- neurotransmitter concentrations found
    end;
   
    if (mod(t,100)==0)
         waitbar(t/Tsim)                  % Progressbar
    end;
                         
                aM = myPyrGatingFuns.alphaM_P(V);
                bM = myPyrGatingFuns.betaM_P(V);
                aH = myPyrGatingFuns.alphaH_P(V);
                bH = myPyrGatingFuns.betaH_P(V);
                aN = myPyrGatingFuns.alphaN_P(V);
                bN = myPyrGatingFuns.betaN_P(V);
                
                % Brought gExc and gInh here for clarity
                %fprintf('t_inner = %4dms\n',t_inner);
                exc_drive = gExc * g_plas(rE)'*s(rE,t_inner); % FROM TO
                inh_drive = gInh * g_plas(rI)'*s(rI,t_inner); % 

               
                %%% Spike detection and temporary storage  &&&&&&&&&&&&&&&&&&&&
        
                if (V>V_sp_thres)
                    if (V==V_spike)
                        V = V_reset;
                        
                        % For numerical stability, use 'natural' values we have found previously
                        m = 0.04;
                        h = 0.25;
                        n = 0.57;

                    else
                        V = V_spike;
                        spikes_post = [spikes_post t];
                        if (Tsim-t) / 10000 <= 5
                            spikes_last5sec = [spikes_last5sec t];
                        end;
                    end
                else
                 % cell dynamics
                        V = V + dt*(gNa*m .^3.*h.*(ENa-V) + gK*n.^4.*(EK-V) + gL*(ERest-V) + I0 ...
                            + inh_drive.*(syn_I-V) + exc_drive.*(syn_E-V));
                
                        
                % Simulate some noise, eps is the level of noise
               %+ eps*randn(length,1)*sqrt(dt);     % Update V                                                                          %Update I-cell voltage.
               % Euler rule update for m, h, n 
                m = m + dt*(aM.*(1-m) - bM.*m);
                h = h + dt*(aH.*(1-h) - bH.*h);                                         % Update h
                n = n + dt*(aN.*(1-n) - bN.*n);                                         % Update n
               
                end                
            
                Vmat(t)   = V ;
                
           
                
          %%% Plasticity  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
          
          % Only look at recent spikes
          % Might be inefficient; possibly keep track of the first spike in the past that might interest us
          %TODO look here

          t_kernel =  t - spikes_post(spikes_post>(t-(5*(BPAP.tau_f+BPAP.tau_s)/dt)));
          kernel_BPAP = BPAP.V_amp*(BPAP.I_f*exp(-t_kernel./BPAP.tau_f)+BPAP.I_s*exp(-t_kernel/BPAP.tau_s));
         
          V_BPAP = sum(kernel_BPAP);
          V_H = ERest + V_BPAP;                              % Magnesium unblocking caused by BPAP
          H = Mg_block(V_H);
                
          I_NMDA = zeros(numDendrites,1);
          
          for d0 = 1:numDendrites                                 % NMDA currents for all synapses
              
              % The next two lines take most (>90%) computation time
              
                %spktimes_small = spktimes_all(:,
               t_kernel_f_NMDA = t - spktimes_all(d0,(spktimes_all(d0,:)<t)&(spktimes_all(d0,:)>0)&(spktimes_all(d0,:)>(t-val)));
               
               % Implicitly assuming that the 'degree of openness' of all ion channels on a dendrite sum up linearly
               % Probably should try to simulate saturation?
               INTER1=NMDA.I_f*exp(-t_kernel_f_NMDA./NMDA.tau_f);
               INTER2=NMDA.I_s*exp(-t_kernel_f_NMDA./NMDA.tau_s);
               f = sum(INTER1+INTER2);
               
               % for debugging
%                history = [history sum(sum(t_kernel_f_NMDA))];
%                if d0==1
%                    if t==1
%                        history = sum(t_kernel_f_NMDA);
%                    else
%                        history = [history sum(t_kernel_f_NMDA)];
%                    end;
%                end;
               
               % NMDA currents
               %if ~(isempty(f))
                    I_NMDA(d0) = g_NMDA*f*H;  % f vector inputs, H 1 number
                    % in article, there is another factor P0 = 0.5, which is the fraction of NMDARs in the closed state that shift to the open state after each presynaptic spike
               %end
          end
          
          
          % Learning curve and slope
          omega = learning_curve(learn_curve,Ca);
          eta   = learn_rate_slope*Ca;
          
          % Ca and synaptic weight dynamics
          
          Ca = Ca + dt*(I_NMDA - Ca/Ca_tau);
          Ca_history = [Ca_history Ca];
          
          g_plas = g_plas + dt*(eta.*(omega-syn_decay_NMDA*g_plas));
                    
          % Synaptic stabilization aka metaplasticity
          if enableMetaplasticity
            g_NMDA = g_NMDA + dt*(-(stab.k_minus*(V_H-ERest).^2 + stab.k_plus).*g_NMDA + stab.k_plus*stab.gt);
          end;
          
          if ~enableInhplasticity
            g_plas(startInh:numDendrites) = 1;  % Remove plasticity from inh synapses
          end;
          
    
end
disp('Main loop done.');

%% Postsynaptic spiking frequency display
numOfSpikes = length(spikes_post);
fprintf('Input frequency : %.0fHz\n', rate_Input);
rate_Output = numOfSpikes/(T0/1000);
fprintf('Output frequency: %.0fHz\n', rate_Output);
time = min(T0,5000);
rate_Output5 = length(spikes_last5sec)/(time/1000);
fprintf('Output frequency (last 5 seconds): %.0fHz\n', rate_Output5);

%% Computation time display
simulationEndTime = clock;
totalComputingTime = etime(simulationEndTime, simulationStartTime);
fprintf('Simulation time: %dms, total computing time: %.1fs.\n', T0, totalComputingTime);

% Figure 1
%FigSpiketrainsAndVoltage(InputBool, Vmat, endExc, numDendrites-endExc, rate_Input, T0, dt, I0)
% Figure 2
%FigWeightHistograms(gExc,gInh,g_plas0,g_plas,rE,rI,endExc,numDendrites-endExc,rate_Input,T0,dt,I0)


% %% Write data to file
% fileName = sprintf('out_last5_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
% cd data_out;
% % Save all the relevant stuff
% %octave: save('-mat7-binary', fileName, 'rate_Input','T0','dt','I0','gExc','gInh','Vmat','g_plas0','g_plas','rE','rI','endExc','startInh','numDendrites','totalComputingTime');
% save(fileName, 'rate_Input', 'rate_Output','T0','dt','I0','gExc','gInh','Vmat','g_plas0','g_plas','rE','rI','endExc','startInh','numDendrites','totalComputingTime','enableMetaplasticity','enableInhplasticity','spktimes_all','Ca_history','spikes_post','g_plas_history', 'spikes_last5sec','rate_Output5');
% cd ..;