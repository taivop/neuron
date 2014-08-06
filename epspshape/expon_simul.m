
s = 1; %(mV)
norm = 0.6968;

tau1 = 50; %(ms)
tau2 = 5; %(ms)

dt = 10;
T0 = 1000 * dt;

V = zeros(1, T0);

spiketime = 3000;

for t=2000:T0
    if t >= spiketime
        exp1 = exp(-(t-spiketime)/dt/tau1);
        exp2 = exp(-(t-spiketime)/dt/tau2);
        V(t) = s/norm * (exp1 - exp2);
    end;
end;

plot(V);