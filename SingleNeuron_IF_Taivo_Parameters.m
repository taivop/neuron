% %% PAR: Basic simulation
% trial_id = 1;                   % Trial identifier
% T0 = 1000;                      % Simulation time (ms)
% dt = 0.1;                       % Simulating Time step (ms)
% tw = 0.5;                       % Writing time step (ms)
% Tsim = T0/dt;                   % num of time steps

%% PAR: Ion channel
gNa = 100;                      % Maximal conductivity Na channel
ENa = 50;                       % Reversal Na channel
gK = 80;                        % Maximal conductivity K channel
EK = -100;                      % Reversal K channel
gL = 0.1;                       % Maximal conductivity leak channel
ERest = -67;                    % Reversal leak channel

%% PAR: Spiking and basal drive
V_sp_thres = -50;               % Voltage to define spike has occurred
V_spike = 40;                   % Voltage a neuron jumps to when spike occurred
V_reset = -90;                  % Voltage a neuron resets to after spiking

% Important parameter to play with
% I0 = 0.15;                      % Basal drive to pyramidal neurons (controls basal rate; 1.5 -> gamma freq (about 40-50 Hz) when isolated)


% %% PAR: Synaptic conductivities
% g_PP = 0.02;                    % Maximal synaptic conductivity (AMPA) on pyramidal neurons
% g_IP = 0.1;                     % Maximal synaptic conductivity (GABA) on pyramidal neurons
% % Inhibitory conductivity (g_IP) should range in 2x...20x excitatory conductivity (g_PP)


%% PAR: Presynaptic neurotransmitter dynamics
% Time constants of presynaptic neurotransmitter dynamics (Pyramidal and inhibitory neurons)
% R - rising time, D - decaying time
% E - excitatory, I - inhibitory
tau_R_E = 0.2;                    
tau_D_E = 2;
tau_R_I = 0.5;
tau_D_I = 10;

syn_E = 0;                      % Reversal potential of excitatory synapses
syn_I = -80;                    % Reversal potential of inhibitory synapses

%% PAR: BPAP plasticity

BPAP.V_amp = 44;               % Amplitude of BPAP in mV
BPAP.I_f = 0.75;               % Relative magnitude fast component BPAP
BPAP.I_s = 0.25;               % Relative magnitude slow component BPAP
BPAP.tau_f = 3;                % Time constant fast component (in ms)
BPAP.tau_s = 35;               % Time constant slow component (in ms)

%% PAR: NMDA plasticity

NMDA.Mg_con = 1;               % Concentration of Mg
NMDA.Ca_Vrest = 130;           % Calcium resting potential (mV)
NMDA.I_f = 70;                 % Relative magnitude fast component NMDA conductance
NMDA.I_s = 30;                 % Relative magnitude slow component NMDA conductance
NMDA.tau_f = 50;               % Time constant fast component (in ms)
NMDA.tau_s = 200;              % Time constant slow component (in ms)


%% PAR: Learning curves

learn_rate_slope = 2e-3;       % Learning rate slope   % RATE of learning % 2e-5
% learn_curve.alfa1 = 0.35;    % Learning curve parameters (control LPT and LTF threshold)
% learn_curve.beta1 = 80;
% learn_curve.alfa2 = 0.55;
% learn_curve.beta2 = 80;

learn_curve.alfa1 = 0.25;      % Learning curve parameters (control LPT and LTF threshold)
learn_curve.beta1 = 60;
learn_curve.alfa2 = 0.4;
learn_curve.beta2 = 20;
%stationary value

% %% PAR: Input trains and # of dendrites
% rate_Input = 30; % Hz
% nrDendrites = 100;
% rE = 1:80;                     % Excitatory synapses
% rI = 81:100;                   % Inhibitory synapses

%% PAR: Various

syn_decay_NMDA = 5e-1;%5e-3         % Lambda penalty for having a too large weight; 1/lambda = max weight

Ca_tau = 20;                   % Calcium passive decay time constant (in ms)

% Long-term synaptic stabilization
stab.k_minus = 8e-7;           % Kinetic constant removal NMDA already speedy 
stab.k_plus = 8e-5;            % Kinetic constant insertion NMDA
stab.gt = 4.5e-3;              % Normalization factor 
% TODO: stab.gt is a normalization factor - in what way? Currently used
% also as an initialization value, see in main code.