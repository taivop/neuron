%% Simulation parameters
% Legend:
% #AR - same as in the ARticle, followed by the value in the article
% #UN - UNknown what the value used in article was

%% Integrate-and-fire model
V_sp_thres = -55;               % #AR-55 (Voltage to define spike has occurred
V_spike = 40;                   % (none in AR) Voltage a neuron jumps to when spike occurred
V_reset = -65;                  % # (not said in AR) Voltage a neuron resets to after spiking

gLeak = 1;                      % #AR1 (implicit) Maximal conductivity of leak channel
gExcMax = 0.03;                 % #AR0.03 Maximal synaptic conductivity (AMPA)
gInhMax = 0.1;                  % #AR0.1 Maximal synaptic conductivity (GABA)
gK = 80;                        % Maximal conductivity K channel
gNa = 100;                      % Maximal conductivity Na channel

VNa = 50;                       % Reversal potential of Na channel
VK = -100;                      % Reversal potential of K channel
VRest = -65;                    % #AR-65 Reversal potential of leak channel
VEx = 0;                        % #AR0 Reversal potential of excitatory synapses
VIn = -65;                      % #AR65 Reversal potential of inhibitory synapses

VRest_adapt = 2;                % #AR2 Resting voltage change upon spike-frequency adaptation (in mV)
tau_VRest_adapt = 100;          % #AR100 Spike-frequency adaptation time constant (in ms)

tau_m = 20;                     % #AR20 Membrane time constant, ms
tau_g = 5;                      % #AR5 Presynaptic drive decay time constant, ms


%% Presynaptic neurotransmitter dynamics
% Time constants of presynaptic neurotransmitter dynamics (Pyramidal and inhibitory neurons)
% R - rising time, D - decaying time
% E - excitatory, I - inhibitory
tau_R_E = 0.2;                    
tau_D_E = 2;
tau_R_I = 0.5;
tau_D_I = 10;


%% BPAP plasticity

BPAP.V_amp = 80;               % #AR42 Amplitude of BPAP (in mV)
BPAP.I_f = 0.75;               % #AR0.75 Relative magnitude fast component BPAP
BPAP.I_s = 0.25;               % #AR0.25 Relative magnitude slow component BPAP
BPAP.tau_f = 3;                % #AR3 Time constant fast component (in ms)
BPAP.tau_s = 35;               % #AR35 Time constant slow component (in ms)
BPAP.arrival_delay = 2;        % #AR2 Delay for BPAP arrival to dendrites (in ms)

%% NMDA plasticity

NMDA.Mg_con = 1;               % #AR1 Concentration of Mg
NMDA.Ca_Vrest = 130;           % #AR130 Calcium resting potential (mV)
NMDA.I_f = 0.7;                % #AR0.7 Relative magnitude fast component NMDA conductance
NMDA.I_s = 0.3;                % #AR0.3 Relative magnitude slow component NMDA conductance
NMDA.tau_f = 50;               % #AR50 Time constant fast component (in ms)
NMDA.tau_s = 200;              % #AR200 Time constant slow component (in ms)
NMDA.P0 = 0.5;                 % #AR0.5 Fraction of NMDARs shifting to open state.

%% Calcium dynamics
Ca_tau = 20;                   % #AR20 Calcium passive decay time constant (in ms)


%% Learning curve (omega)
% These control LPT and LTF threshold	

learn_curve.alfa1 = 0.35;	   % #AR0.25 | 2002 0.35
learn_curve.beta1 = 80;		   % #AR60   | 2002 80
learn_curve.alfa2 = 0.55;	   % #AR0.4  | 2002 0.55
learn_curve.beta2 = 80;		   % #AR20   | 2002 80

%% Metaplasticity
stab.gt = 4.5e-3;       	    % #AR4.5e-3 Starting value for g_NMDA.
stab.k_minus = 8e-9;            % #AR8e-9
stab.k_plus = 8e-7;             % #AR8e-7

%% Various
dt = 0.1;                       % #AR1 Simulating Time step (ms)
syn_decay_NMDA = 0.25;         % #AR0.005 Lambda penalty for having a too large weight; 1/lambda = max weight
eta_slope = 2e-5;               % #AR2e-5