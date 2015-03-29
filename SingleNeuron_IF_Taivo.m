
function [filePath] = SingleNeuron_IF_Taivo(T_sec, rate_Input, filename_spec)
% T_sec - simulation time (in seconds), MUST BE INTEGER NUMBER OF SECONDS
% rate_Input - average input rate to all neurons
% filename_spec - the tag you want to add into the name of the output data file.

%% Script initialization
addpath('helper_functions', 'input_generation', 'parameters');
simulationStartTime = clock;

%% PAR: Set simulation parameters
enable_metaplasticity = 0;      % enable metaplasticity?
enable_inhplasticity = 0;       % enable inhibitory plasticity?
enable_inhdrive = 1;            % enable inhibition at all?
enable_onlyoneinput = 1;        % take input from only 1 synapse?
enable_100x_speedup = 1;        % should we speed up the simulation?
enable_2004 = 1;                % are we running 2004 simulations?

desiredCorrelation = 0; % desired correlation for input to excitatory synapses

% Load parameters
if enable_2004
    SingleNeuron_IF_Taivo_Parameters_2004;
else
    SingleNeuron_IF_Taivo_Parameters_2002;
end;

T0 = T_sec * 1000;              % Simulation length in ms
Tsim = T0/dt;                   % num of time steps
I0 = 0.0;                       % Basal drive to pyramidal neurons (controls basal rate; 1.5 -> gamma freq (about 40-50 Hz) when isolated)
EPSP_amplitude = 1;             % in mV, rough value
fprintf('Simulation time: %ds\n', T_sec);
fprintf('lambda = %.3f\n', syn_decay_NMDA);
fprintf('desired correlation = %.2f\n', desiredCorrelation);
fprintf('100x speedup enabled: %d\n', enable_100x_speedup);

% Input trains and # of dendrites
numDendrites = 120;
endExc = 100;                    % Last excitatory synapse
if enable_onlyoneinput
    numDendrites = 2;
    endExc = 1;
end;
if enable_100x_speedup && enable_2004
    eta_slope = eta_slope * 100;
    syn_decay_NMDA = syn_decay_NMDA * 100;
    stab.k_minus = 100 * stab.k_minus;
    stab.k_plus = 100 * stab.k_plus;
end;

startInh = endExc + 1;          % First inhibitory synapse
rE = 1:endExc;                  % Excitatory synapses
rI = startInh:numDendrites;      % Inhibitory synapses

%% Initializations
V = -60.0 + 0*10*rand(1);             % Initial postsynaptic voltage

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

if ~enable_2004
    initialWeight = 0.25 / syn_decay_NMDA;  % initialise weights to their stable values
    weight_randomness = rand(numDendrites,1) * 0.10 - 0.05; % generate randomness of +- 5%
else
    initialWeight = 1;
    weight_randomness = rand(numDendrites,1) * 0.10 - 0.05;
end;

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
f_history = [];
g_plas_history = [];

% Initialisations for some loop internal variables
spikes_post=[];                                 % Output spike times
spikes_last5sec = [];
Vmat    = zeros (1,Tsim);                       % Voltage of postsynaptic neuron
spktimes_all = [];

% Time window to check in the past for release of neurotransmitter
val=5*(NMDA.tau_f+NMDA.tau_s)/dt;

%% MAIN LOOP

m_history = [];
n_history = [];
h_history = [];

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

        [spikes_binary, spiketimes] = GenerateInputSpikesMacke(endExc, rate_Input, desiredCorrelation, 1000, dt, 0);
        [spikes_binary2, spiketimes2] = GenerateInputSpikesMacke(numDendrites-endExc, rate_Input, 0, 1000, dt, 0);
        
        fprintf('             measured total input frequency: %.0fHz\n', sum(sum(spiketimes ~= 0)));
        
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
        EPSP_amplitude_norm = EPSP_amplitude / 3.7;   % we use this to scale EPSP amplitude to desired value
        
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
                %fprintf('t_inner = %4dms\n',t_inner);
                exc_drive = gExc * g_plas(rE)'*s(rE,t_inner)*EPSP_amplitude_norm;
                inh_drive = gInh * g_plas(rI)'*s(rI,t_inner)*EPSP_amplitude_norm;
                
                if ~enable_inhdrive
                    inh_drive = zeros(size(inh_drive));
                end;
               
               
                %%% Spike detection and temporary storage  &&&&&&&&&&&&&&&&&&&&
        
                if (V>V_sp_thres)
                    if (V==V_spike)
                        V = V_reset;
                        
                        % For numerical stability, use 'natural' values we
                        % have found previously by seeing where they are
                        % if no input is given to neuron.
                        % TODO: these may be specific to dt=0.1 and that's why other dt values don't work
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
                V = V + dt * (gNa*m .^3.*h.*(ENa-V) ...
                      + gK*n.^4.*(EK-V) + gL*(ERest-V) + I0 ...
                      + inh_drive.*(syn_I-V) + exc_drive.*(syn_E-V));
                
                        
                % Simulate some noise, eps is the level of noise
               %+ eps*randn(length,1)*sqrt(dt);     % Update V                                                                          %Update I-cell voltage.
               % Euler rule update for m, h, n 
                m = m + dt*(aM.*(1-m) - bM.*m);
                h = h + dt*(aH.*(1-h) - bH.*h);
                n = n + dt*(aN.*(1-n) - bN.*n);
               
                end                
            
                Vmat(t)   = V ;
                
                
          %%% Plasticity  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
          
          % Only look at recent spikes
          % Might be inefficient; possibly keep track of the first spike in the past that might interest us
          %TODO look here
          t_kernel =  t - spikes_post(spikes_post>(t-(5*(BPAP.tau_f+BPAP.tau_s)/dt)));
          kernel_BPAP = BPAP.V_amp*(BPAP.I_f*exp(-t_kernel./(BPAP.tau_f/dt))+BPAP.I_s*exp(-t_kernel/(BPAP.tau_s/dt)));
         
          V_BPAP = sum(kernel_BPAP);
          V_H = ERest + V_BPAP;                              % Magnesium unblocking caused by BPAP
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
          if enable_2004
            omega = learning_curve2004(learn_curve,Ca);
            eta_val = eta2004(Ca,eta_slope);
          else
            omega = learning_curve2002(learn_curve,Ca);
            eta_val = eta2002(Ca,0); %TODO    % 0 is here because the function eta2002 doesn't use the second argument
          end;
          
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
          m_history = [m_history m];
          n_history = [n_history n];
          h_history = [h_history h];
          
    
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
save(filePath, 'rate_Input', 'rate_Output','T0','dt','I0','gExc','gInh', ...
    'Vmat','g_plas0','g_plas','rE','rI','endExc','startInh','numDendrites', ...
    'totalComputingTime','enable_metaplasticity','enable_inhplasticity', ...
    'spktimes_all','Ca_history','spikes_post', 'g_plas_history', ...
    'spikes_last5sec','rate_Output5','syn_decay_NMDA', ...
    'EPSP_amplitude_norm', 'STOPPER', 'enable_inhdrive', 'EPSP_amplitude', ...
    'f_history', 'spikes_binary', 'spiketimes', 's', 'InputBool');
fprintf('Successfully wrote output to %s\n', filePath);