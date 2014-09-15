%% Simulation parameters
% Legend:
% #AR - same as in the ARticle, followed by the value in the article
% #UN - UNknown what the value used in article was

%% Ion channel
gNa = 100;                      % Maximal conductivity Na channel
ENa = 50;                       % Reversal Na channel
gK = 80;                        % Maximal conductivity K channel
EK = -100;                      % Reversal K channel
gL = 0.1;                       % original 0.1 Maximal conductivity leak channel
ERest = -67;                    % Reversal leak channel

%% Spiking and basal drive
V_sp_thres = -50;               % Voltage to define spike has occurred
V_spike = 40;                   % Voltage a neuron jumps to when spike occurred
V_reset = -90;                  % Voltage a neuron resets to after spiking



%% Presynaptic neurotransmitter dynamics
% Time constants of presynaptic neurotransmitter dynamics (Pyramidal and inhibitory neurons)
% R - rising time, D - decaying time
% E - excitatory, I - inhibitory
tau_R_E = 0.2;                    
tau_D_E = 2;
tau_R_I = 0.5;
tau_D_I = 10;

syn_E = 0;                      % Reversal potential of excitatory synapses
syn_I = -80;                    % Reversal potential of inhibitory synapses

% Synaptic conductivities
g_PP = 0.03;                    %#AR0.03 Maximal synaptic conductivity (AMPA) on pyramidal neurons (had 0.017 previously)
g_IP = 0.1;                     %#AR0.1 Maximal synaptic conductivity (GABA) on pyramidal neurons
% Inhibitory conductivity (g_IP) should range in 2x...20x excitatory conductivity (g_PP)

% Set maximal conductivities for inh and exc synapses
gInh = g_IP;
gExc = g_PP;

%% BPAP plasticity

BPAP.V_amp = 100;              % #AR(42mV - base_value ~= 108mV) Amplitude of BPAP in mV
BPAP.I_f = 0.75;               % #AR0.75 Relative magnitude fast component BPAP
BPAP.I_s = 0.25;               % #AR0.25 Relative magnitude slow component BPAP
BPAP.tau_f = 3;                % #AR3 Time constant fast component (in ms)
BPAP.tau_s = 35;               % #AR35 Time constant slow component (in ms)

%% NMDA plasticity

NMDA.Mg_con = 1;               % #AR1 Concentration of Mg
NMDA.Ca_Vrest = 130;           % #AR130 Calcium resting potential (mV)
NMDA.I_f = 0.7;                % #AR0.7 Relative magnitude fast component NMDA conductance
NMDA.I_s = 0.3;                % #AR0.3 Relative magnitude slow component NMDA conductance
NMDA.tau_f = 50;               % #AR50 Time constant fast component (in ms)
NMDA.tau_s = 200;              % #AR200 Time constant slow component (in ms)

%% Calcium dynamics
Ca_tau = 20;                   % #AR20 Calcium passive decay time constant (in ms)


%% Learning curve (omega)
% These control LPT and LTF threshold	

learn_curve.alfa1 = 0.35;	   % #AR0.25 | 2002 0.35
learn_curve.beta1 = 80;		   % #AR60   | 2002 80
learn_curve.alfa2 = 0.55;	   % #AR0.4  | 2002 0.55
learn_curve.beta2 = 80;		   % #AR20   | 2002 80

%% Various
dt = 0.1;                       % #AR1 Simulating Time step (ms)
syn_decay_NMDA = 0.005;         % #AR0.005 Lambda penalty for having a too large weight; 1/lambda = max weight
stab.gt = - 0.5 * 4.5e-3;		% #AR0.5*4.5e-3 (probably) Starting value for g_NMDA. Is already multiplied with P0 (which is 0.5). Was 4.5e-3 previously.
eta_slope = 2e-5;               % #AR2e-5