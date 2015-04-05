
function [filePath] = SingleNeuron_IF_Taivo(T_sec, rate_Input, filename_spec, varargin)
% T_sec - simulation time (in seconds), MUST BE INTEGER NUMBER OF SECONDS
% rate_Input - average input rate to all neurons
% filename_spec - the tag you want to add into the name of the output data file.

%% Script initialization & paths
addpath('helper_functions', 'input_generation', 'parameters');

% Paths for input generation
p = 'input_generation/mackeetal';
addpath(p)
addpath(fullfile(p,'lib'))
addpath(fullfile(p,'interface'))

simulationStartTime = clock;

%% PAR: Set simulation parameters
desiredCorrelation = 0; % desired correlation for input to excitatory synapses

% Load parameters
SingleNeuron_IF_Taivo_Parameters_2004;

T0 = T_sec * 1000;              % Simulation length in ms
Tsim = T0/dt;                   % num of time steps
I0 = 0.0;                       % Basal drive to pyramidal neurons (controls basal rate; 1.5 -> gamma freq (about 40-50 Hz) when isolated)

%% Assign optional function argument values if any were given, otherwise use defaults
p = inputParser;
addParameter(p,'enable_metaplasticity',1);
addParameter(p,'enable_inhplasticity',0);
addParameter(p,'enable_inhdrive',1);
addParameter(p,'enable_onlyoneinput',0);
addParameter(p,'enable_100x_speedup',1);
addParameter(p,'enable_groupedinputs',0); % if enabled, input rate parameter only applies to inh inputs
addParameter(p,'numDendrites',120);
addParameter(p,'endExc',100);
addParameter(p,'EPSP_amplitude', 3); % in mV, rough value

parse(p, varargin{:});
parsedParams = p.Results; % for saving

numDendrites = p.Results.numDendrites;
endExc = p.Results.endExc;

%% Change parameters based on options given
if p.Results.enable_onlyoneinput
    numDendrites = 2;
    endExc = 1;
end;
if p.Results.enable_100x_speedup
    eta_slope = eta_slope * 100;
    syn_decay_NMDA = syn_decay_NMDA * 100;
    stab.k_minus = 100 * stab.k_minus;
    stab.k_plus = 100 * stab.k_plus;
end;

startInh = endExc + 1;          % First inhibitory synapse
rE = (1:endExc)';                  % Excitatory synapses
rI = (startInh:numDendrites)';      % Inhibitory synapses


fprintf('Simulation time: %ds\n', T_sec);
fprintf('lambda = %.3f\n', syn_decay_NMDA);
fprintf('desired correlation = %.2f\n', desiredCorrelation);
fprintf('100x speedup enabled: %d\n', p.Results.enable_100x_speedup);

%% Initializations
V = VRest + 0*10*rand(1);             % Initial postsynaptic voltage

% Initialise weights with some randomness
initialWeightExc = 2;
initialWeightInh = 1;
weight_randomness = rand(size(rE)) * 0.10 - 0.05;

% Some parameters to describe how open the gates are		
myPyrGatingFuns = makePyrGatingFuns;		
aM = myPyrGatingFuns.alphaM_P(V);		
bM = myPyrGatingFuns.betaM_P(V);		
aH = myPyrGatingFuns.alphaH_P(V);		
bH = myPyrGatingFuns.betaH_P(V);		
aN = myPyrGatingFuns.alphaN_P(V);		
bN = myPyrGatingFuns.betaN_P(V);		
m = 0.016042971256324;		
h = 0.995496003155816;		
n = 0.040275499396172;		

% g_plas are the coefficients we use to get conductivities from their base values.
% They are named 'w' in the article.
g_plas = ones(numDendrites, 1);
g_plas(rE) = (g_plas(rE) + weight_randomness) * initialWeightExc;
g_plas(rI) = g_plas(rI) * initialWeightInh;
if p.Results.enable_onlyoneinput
    g_plas(2:end) = 0;
end;
g_plas0 = g_plas;                               % Save initial values
Ca = zeros(numDendrites,1);                     % Array for calcium concentration in dendrites
g_NMDA = stab.gt;                               % Initialize NMDA channel conductivity to stable point (will be changed with metaplasticity)

% Initialisations to save some variables over time
Ca_history = [];
f_history = [];
g_plas_history = [];
VRest_history = [];
gExc_history = [];
g_NMDA_history = [];

% Initialisations for some loop internal variables
spikes_post=[];                                 % Output spike times
spikes_last5sec = [];
Vmat    = zeros (1,Tsim);                       % Voltage of postsynaptic neuron
spktimes_all = [];
VRestChanging = VRest;                          % Initialise resting potential
gExc = 0;
gInh = 0;

% Time window to check in the past for release of neurotransmitter
val=5*(NMDA.tau_f+NMDA.tau_s)/dt;

%% MAIN LOOP

disp('Running main loop...');
%waitbar(0);
timesteps_in_1sec = 1000 / dt;

for t=1: Tsim                       % Loop over time
    largebin = fix((t-1)/timesteps_in_1sec);     % STARTS FROM ZERO. find out which large time bin we are in
    t_inner = mod(t,timesteps_in_1sec);          % find out where we are in the current large time bin
    if t_inner == 0
        t_inner = timesteps_in_1sec;
    end;
    
    if (mod(t, timesteps_in_1sec)==1)
        fprintf('t = %5dms, mean exc weight %.2f\n',largebin * 1000 + t_inner, mean(g_plas(rE)));
        g_plas_history = [g_plas_history g_plas];
        
        
        % Generate input spikes
        if p.Results.enable_groupedinputs
            [spikes_binary, spiketimes] = GenerateInputSpikesGroups(1000, dt, 0);
        else
            [spikes_binary, spiketimes] = GenerateInputSpikesUncorrelated(endExc, rate_Input, 1000, dt, 0);
        end;
        
        [spikes_binary2, spiketimes2] = GenerateInputSpikesUncorrelated(numDendrites-endExc, rate_Input, 1000, dt, 0);            
        
        fprintf('             measured total input rate: %.0fHz\n', sum(sum(spiketimes ~= 0)));
        %fprintf('             measured total output rate: %.0fHz\n', sum(sum(spiketimes ~= 0)));
        
        InputBool = [spikes_binary;spikes_binary2];
        
        % Zero-padding for concatenation
        spktimes =  zeros(numDendrites,max(size(spiketimes,2),size(spiketimes2,2)));
        spktimes(1:endExc,1:size(spiketimes,2)) = spiketimes;
        spktimes(startInh:numDendrites,1:size(spiketimes2,2)) = spiketimes2;
        
        % We want to keep only the last 1250 ms (the value of 'val').
        % So let's keep only the last two large bins (the last 2000ms).
        if largebin == 0
            spktimes_new = spktimes;
            spktimes_all = spktimes_new;
        else
            spktimes_all = [spktimes_new (spktimes + timesteps_in_1sec * largebin)];
            spktimes_new = spktimes + timesteps_in_1sec * largebin;
        end;
        %-- input spikes generated
        
        % Get neurotransmitter concentrations from presynaptic spikes
        V_Input = InputBool*100-70;
        
        if largebin==0              % if we are starting the simulation, set to default values
            s_lastE = 8.315211133249553e-06;      % found natural initialisation values
            s_lastI = 1.663028398217609e-05;      % by running simulation with no input
        else
            s_lastE = s(rE,end);   % if already simulating, use value from previous timebin
            s_lastI = s(rI,end);
        end;
        
        s = zeros(size(InputBool));  % plays as external input drive
        
        STOPPER = 1;
        EPSP_amplitude_norm = p.Results.EPSP_amplitude / 2.6; % we use this to scale EPSP amplitude to desired value
        
        s(rE,1) = s_lastE + dt*(((1+tanh(V_Input(rE,1)/10))/2).*(1- STOPPER * s_lastE)/tau_R_E -s_lastE/tau_D_E);
        s(rI,1) = s_lastI + dt*(((1+tanh(V_Input(rI,1)/10))/2).*(1- STOPPER * s_lastI)/tau_R_I -s_lastI/tau_D_I);
        
        for t2=2:timesteps_in_1sec  
            s(rE,t2) = s(rE,t2-1) + dt*(((1+tanh(V_Input(rE,t2)/10))/2).*(1- STOPPER * s(rE,t2-1))/tau_R_E -s(rE,t2-1)/tau_D_E);   % neurotransmitter concentration at the synapse
            s(rI,t2) = s(rI,t2-1) + dt*(((1+tanh(V_Input(rI,t2)/10))/2).*(1- STOPPER * s(rI,t2-1))/tau_R_I -s(rI,t2-1)/tau_D_I);   % neurotransmitter concentration at the synapse
        end
        
        %-- neurotransmitter concentrations found
    end;
    
    
                aM = myPyrGatingFuns.alphaM_P(V);
                bM = myPyrGatingFuns.betaM_P(V);
                aH = myPyrGatingFuns.alphaH_P(V);
                bH = myPyrGatingFuns.betaH_P(V);
                aN = myPyrGatingFuns.alphaN_P(V);
                bN = myPyrGatingFuns.betaN_P(V);
                
                % Brought gExc and gInh here for clarity
                gExc = gExcMax * g_plas(rE)'*s(rE,t_inner)*EPSP_amplitude_norm;
                gInh = gInhMax * g_plas(rI)'*s(rI,t_inner)*EPSP_amplitude_norm;
                
                if ~p.Results.enable_inhdrive
                    gInh = zeros(size(gInh));
                end;
               
               
                %%% Spike detection and temporary storage  &&&&&&&&&&&&&&&&&&&&
        
                if (V>V_sp_thres)
                    if (V==V_spike)
                        V = V_reset;
                        VRestChanging = VRestChanging - VRest_adapt;
                        
                        % For numerical stability, use 'natural' values we		
                        % have found previously by seeing where they are		
                        % if no input is given to neuron.		
                        m = 0.016042971256324;		
                        h = 0.995496003155816;		
                        n = 0.040275499396172;

                    else
                        V = V_spike;
                        spikes_post = [spikes_post t];
                        if (Tsim-t) / timesteps_in_1sec <= 5
                            spikes_last5sec = [spikes_last5sec t];
                        end;
                    end
                else
                 % cell dynamics
                 V = V + dt * (gNa*m .^3.*h.*(VNa-V) ...
                       + gK*n.^4.*(VK-V) + gLeak*(VRestChanging-V) + I0 ...		
                       + gInh.*(VIn-V) + gExc.*(VEx-V));
                   
                % Euler update for m, h, n 
                m = m + dt*(aM.*(1-m) - bM.*m);
                h = h + dt*(aH.*(1-h) - bH.*h);
                n = n + dt*(aN.*(1-n) - bN.*n);   
                  
                % VRest decay towards baseline
                VRestChanging = VRestChanging + dt / tau_VRest_adapt * (VRest - VRestChanging); 
               
                end                
            
                Vmat(t)   = V ;
                
                
          %%% Plasticity  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
          
          % Only look at recent spikes
          % Might be inefficient; possibly keep track of the first spike in the past that might interest us
          %TODO look here
          t_kernel =  t - spikes_post(spikes_post>(t-(5*(BPAP.tau_f+BPAP.tau_s)/dt)));
          kernel_BPAP = BPAP.V_amp*(BPAP.I_f*exp(-t_kernel./(BPAP.tau_f/dt))+BPAP.I_s*exp(-t_kernel/(BPAP.tau_s/dt)));
          
          V_BPAP = sum(kernel_BPAP);
          V_H = VRestChanging + V_BPAP;                              % Magnesium unblocking caused by BPAP
          H = Mg_block(V_H) * (V - NMDA.Ca_Vrest);
          
          % ---START former loop
          t_kernel_f_NMDA = (t - spktimes_all) .* (spktimes_all>0 & spktimes_all<t & spktimes_all>(t-val));
          tauf = -t_kernel_f_NMDA./(NMDA.tau_f / dt);
          taus = -t_kernel_f_NMDA./(NMDA.tau_s / dt);
          tauf(tauf==0) = -Inf;
          taus(taus==0) = -Inf;
          f = sum(NMDA.I_f*exp(tauf)+NMDA.I_s*exp(taus),2);
          f_history = [f_history f(1)];
          I_NMDA = (g_NMDA*f*H);
          % ---END former loop
          
          % Learning curve and slope
          omega = learning_curve2004(learn_curve,Ca);
          eta_val = eta2004(Ca,eta_slope);
          
          % Ca and synaptic weight dynamics
          Ca = Ca + dt*(I_NMDA - Ca/Ca_tau);
          g_plas = g_plas + dt*(eta_val.*(omega-syn_decay_NMDA*g_plas));
                    
          % Synaptic stabilization aka metaplasticity
          g_NMDA_history = [g_NMDA_history g_NMDA];
          if p.Results.enable_metaplasticity  
            g_NMDA = g_NMDA + dt*(-(stab.k_minus*(V_H-VRestChanging).^2 + stab.k_plus).*g_NMDA + stab.k_plus*stab.gt);
          end;
          
          if ~p.Results.enable_inhplasticity
            g_plas(startInh:numDendrites) = initialWeightInh;  % Remove plasticity from inh synapses
          end;
          
          if p.Results.enable_onlyoneinput
              g_plas(2:end) = 0;
          end;
              
          Ca_history = [Ca_history Ca(1)];
          VRest_history = [VRest_history VRestChanging];
          gExc_history = [gExc_history gExc];
          
    
end
disp('Main loop done.');

%% Postsynaptic spiking frequency display
numOfSpikes = length(spikes_post);
fprintf('Desired input frequency : %.0fHz\n', rate_Input);
rate_Output = numOfSpikes/(T0/1000);
fprintf('Output frequency: %.0fHz\n', rate_Output);
time = min(T0,5000);
rate_Output5 = length(spikes_last5sec)/(time/1000);
fprintf('Output frequency (last 5 seconds): %.0fHz\n', rate_Output5);

%% Computation time display
simulationEndTime = clock;
totalComputingTime = etime(simulationEndTime, simulationStartTime);
fprintf('Simulation time: %ds, total computing time: %.1fs.\n', T_sec, totalComputingTime);


%% Write data to file
folderName = 'data_out';
if strcmpi(filename_spec,'default') || strcmpi(filename_spec,'')
    filePath = sprintf('%s/out_%s.mat', folderName, datestr(now,'yyyy-mm-dd_HH-MM-SS'));
else
    filePath = sprintf('%s/out_%s_%s.mat', folderName, filename_spec, datestr(now,'yyyy-mm-dd_HH-MM-SS'));
end;
% Save all the relevant stuff
save(filePath, 'rate_Input', 'rate_Output','T0','dt','I0','gExcMax','gInhMax', ...
    'Vmat','g_plas0','g_plas','rE','rI','endExc','startInh','numDendrites', ...
    'totalComputingTime','parsedParams', ...
    'spktimes_all','Ca_history','spikes_post', 'g_plas_history', ...
    'spikes_last5sec','rate_Output5','syn_decay_NMDA', ...
    'EPSP_amplitude_norm', 'STOPPER', ...
    'f_history', 'spikes_binary', 'spiketimes', 's', 'InputBool', ...
    'VRest_history', 'gExc_history', 'stab');
fprintf('Successfully wrote output to %s\n', filePath);