function [g_plas_history, rate_Output] = SingleNeuron_IF_Taivo_STDP(T0, deltaT, filename_spec)
% T0 - total simulation time
% deltaT = postsyn_spike_time - presyn_spike_time
% filename_spec - the tag you want to add into the name of the output data file.

%% Script initialization
simulationStartTime = clock;

% Load parameters
SingleNeuron_IF_Taivo_Parameters_2002;

%% PAR: Set simulation parameters
Tsim = T0/dt;                   % num of time steps
enable_metaplasticity = 0;      % enable metaplasticity?
enable_inhplasticity = 0;       % enable inhibitory plasticity?
enable_inhdrive = 0;            % enable inhibition at all?
enable_onlyoneinput = 1;        % take input from only 1 synapse?

I0 = 0.0;                       % Basal drive to pyramidal neurons (controls basal rate; 1.5 -> gamma freq (about 40-50 Hz) when isolated)
EPSP_amplitude = 1;             % in mV, rough value
fprintf('I0 = %.2f\n', I0);
fprintf('lambda = %.2f\n', syn_decay_NMDA);

% Input trains and # of dendrites
numDendrites = 2;
endExc = 1;
startInh = endExc + 1;          % First inhibitory synapse
rE = 1:endExc;                  % Excitatory synapses
rI = startInh:numDendrites;     % Inhibitory synapses

%% Initializations
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

initialWeight = 0.25 / syn_decay_NMDA;  % initialise weights to their stable values
% generate randomness of +- 5%
weight_randomness = rand(numDendrites,1) * 0.10 - 0.05;

% g_plas are the coefficients we use to get conductivities from their base values.
% They are named 'w' in the article.
g_plas = (ones(numDendrites,1) + weight_randomness) .* initialWeight;                   % Array with all synaptic weights (evolves during plasticity)
if enable_onlyoneinput
    g_plas(2:end) = 0;
end;
g_plas0 = g_plas;                               % Save initial values for plotting later.
Ca = zeros(numDendrites,1);                     % Array for calcium concentration in dendrites
g_NMDA = stab.gt;                               % Initialize NMDA channel conductivity to stable point.

% Initialisations to save some variables over time
Ca_history = [];
g_plas_history = [];
H_history = [];
I_NMDA_history = [];
f_history = [];

% Initialisations for some loop internal variables
spikes_post=[];                                 % Output spike times
spikes_last5sec = [];
Vmat    = zeros (1,Tsim);                       % Voltage of postsynaptic neuron
spktimes_all = [];

% Time window to check in the past for release of neurotransmitter
val=5*(NMDA.tau_f+NMDA.tau_s)/dt;

%% MAIN LOOP

disp('Running main loop...');
%waitbar(0);
for t=1: Tsim                       % Loop over time
    largebin = fix((t-1)/10000);     % STARTS FROM ZERO. find out which large time bin we are in
    t_inner = mod(t,10000);          % find out where we are in the current large time bin
    if t_inner == 0
        t_inner = 10000;
    end;
    
    if (mod(t,10000)==1)
        fprintf('t = %5dms, mean exc weight %.2f\n',largebin * 1000 + t_inner, mean(g_plas(rE)));
        g_plas_history = [g_plas_history g_plas];
        
        
        % Generate input spikes
        desiredCorrelation = 0; % desired correlation for input to excitatory synapses

        [spikes_binary, spiketimes] = GenerateInputSpikes_STDP(-deltaT);
        [spikes_binary2, spiketimes2] = GenerateEmptyInput;

        InputBool = [spikes_binary;spikes_binary2];
        spktimes =  zeros(numDendrites,max(size(spiketimes,2),size(spiketimes2,2)));
        spktimes(1:endExc,1:size(spiketimes,2)) = spiketimes;
        spktimes(startInh:numDendrites,1:size(spiketimes2,2)) = spiketimes2;
        
        % We want to keep only the last 1250 ms (the value of 'val').
        % So let's keep only the last two large bins (the last 2000ms).
        if largebin == 0
            spktimes_new = spktimes;
            spktimes_all = spktimes_new;
        else
            spktimes_all = [spktimes_new (spktimes + 10000 * largebin)];
            spktimes_new = spktimes + 10000 * largebin;
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
        
        STOPPER = 0;
        RUINER = EPSP_amplitude * 1/2.16;
        
        s(rE,1) = s_lastE + dt*(((1+tanh(V_Input(rE,1)/10))/2).*(1- STOPPER * s_lastE)/tau_R_E -s_lastE/tau_D_E);
        s(rI,1) = s_lastI + dt*(((1+tanh(V_Input(rI,1)/10))/2).*(1- STOPPER * s_lastI)/tau_R_I -s_lastI/tau_D_I);
        
        for t2=2:10000  
            s(rE,t2) = s(rE,t2-1) + dt*(((1+tanh(V_Input(rE,t2)/10))/2).*(1- STOPPER * s(rE,t2-1))/tau_R_E -s(rE,t2-1)/tau_D_E);   % neurotransmitter concentration at the synapse
            s(rI,t2) = s(rI,t2-1) + dt*(((1+tanh(V_Input(rI,t2)/10))/2).*(1- STOPPER * s(rI,t2-1))/tau_R_I -s(rI,t2-1)/tau_D_I);   % neurotransmitter concentration at the synapse
        end
        
        %-- neurotransmitter concentrations found
    end;
   
    if (mod(t,100)==0)
         %waitbar(t/Tsim)                  % Progressbar
    end;
                         
                aM = myPyrGatingFuns.alphaM_P(V);
                bM = myPyrGatingFuns.betaM_P(V);
                aH = myPyrGatingFuns.alphaH_P(V);
                bH = myPyrGatingFuns.betaH_P(V);
                aN = myPyrGatingFuns.alphaN_P(V);
                bN = myPyrGatingFuns.betaN_P(V);
                
                % Brought gExc and gInh here for clarity
                %fprintf('t_inner = %4dms\n',t_inner);
                exc_drive = gExc * g_plas(rE)'*s(rE,t_inner)*RUINER; % FROM TO
                inh_drive = gInh * g_plas(rI)'*s(rI,t_inner)*RUINER; %
                
                if ~enable_inhdrive
                    inh_drive = zeros(size(inh_drive));
                end;

               
                %%% Spike detection and temporary storage  &&&&&&&&&&&&&&&&&&&&
                
                % MAKE ARTIFICIAL POSTSYNAPTIC SPIKE
        
                if (V>V_sp_thres || mod(t,10000) == 5000)  % ALWAYS SPIKE AT 500ms
                    if (V==V_spike)
                        V = V_reset;
                        
                        % For numerical stability, use 'natural' values we have found previously
                        m = 0.04;
                        h = 0.25;
                        n = 0.57;

                    else
                        V = V_spike;
                        spikes_post = [spikes_post t];
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
          t_kernel =  t - spikes_post(spikes_post>(t-(5*(BPAP.tau_f+BPAP.tau_s)/dt)));
          kernel_BPAP = BPAP.V_amp*(BPAP.I_f*exp(-t_kernel./BPAP.tau_f)+BPAP.I_s*exp(-t_kernel/BPAP.tau_s));
          V_BPAP = sum(kernel_BPAP);
          V_H = ERest + V_BPAP;                              % Magnesium unblocking caused by BPAP
          H = Mg_block(V_H) * (V - NMDA.Ca_Vrest);
          Mg_block(V_H); % does vary, so this is good
          %H_history = [H_history H];
          
          % ---START former loop
          t_kernel_f_NMDA = (t - spktimes_all) .* (spktimes_all>0 & spktimes_all<t & spktimes_all>(t-val));
          tauf = -t_kernel_f_NMDA./NMDA.tau_f;
          taus = -t_kernel_f_NMDA./NMDA.tau_s;
          tauf(tauf==0) = -Inf;
          taus(taus==0) = -Inf;
          f = sum(NMDA.I_f*exp(tauf)+NMDA.I_s*exp(taus),2);
          I_NMDA = (g_NMDA*f*H);
          %f_history = [f_history f(1)];
          %I_NMDA_history = [I_NMDA_history I_NMDA(1)];
          % ---END former loop
          %fprintf('size of vectorised I_NMDA is %dx%d\n',size(I_NMDA,1),size(I_NMDA,2));
          
          % Learning curve and slope
          omega = learning_curve2002(learn_curve,Ca);
          eta_val = eta2002(Ca);
          
          % Ca and synaptic weight dynamics
          
          Ca = Ca + dt*(I_NMDA - Ca/Ca_tau);
          g_plas = g_plas + dt*(eta_val.*(omega-syn_decay_NMDA*g_plas));
                    
          % Synaptic stabilization aka metaplasticity
          if enable_metaplasticity
            g_NMDA = g_NMDA + dt*(-(stab.k_minus*(V_H-ERest).^2 + stab.k_plus).*g_NMDA + stab.k_plus*stab.gt);
          end;
          
          if ~enable_inhplasticity
              % TODO: what should be the (unchanging) weight of inh
              % synapses?   
            g_plas(startInh:numDendrites) = initialWeight;  % Remove plasticity from inh synapses
          end;
          
          if enable_onlyoneinput
              g_plas(2:end) = 0;
          end;
              
          Ca_history = [Ca_history Ca(1)];
          
    
end
disp('Main loop done.');

%% Postsynaptic spiking frequency display
numOfSpikes = length(spikes_post);
rate_Output = numOfSpikes/(T0/1000);
fprintf('Output frequency: %.0fHz\n', rate_Output);

%% Computation time display
simulationEndTime = clock;
totalComputingTime = etime(simulationEndTime, simulationStartTime);
fprintf('Simulation time: %dms, total computing time: %.1fs.\n', T0, totalComputingTime);


%% Write data to file
if strcmpi(filename_spec,'default') || strcmpi(filename_spec,'')
    fileName = sprintf('out_%s.mat', datestr(now,'yyyy-mm-dd_HH-MM-SS'));
else
    fileName = sprintf('out_%s_%s.mat', filename_spec, datestr(now,'yyyy-mm-dd_HH-MM-SS'));
end;
cd data_out;
% Save all the relevant stuff
save(fileName, 'rate_Output','T0','dt','I0','gExc','gInh', ...
    'Vmat','g_plas0','g_plas','rE','rI','endExc','startInh','numDendrites', ...
    'totalComputingTime','enable_metaplasticity','enable_inhplasticity', ...
    'spktimes_all','Ca_history','spikes_post', 'g_plas_history', ...
    'spikes_last5sec','syn_decay_NMDA', 'RUINER', 'STOPPER', ...
    'enable_inhdrive', 'EPSP_amplitude', 'H_history', 'I_NMDA_history', ...
    'f_history', 'deltaT');
fprintf('Successfully wrote output to %s\n', fileName);
cd ..;