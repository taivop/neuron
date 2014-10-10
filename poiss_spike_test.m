N0 = 50

spktimes_all = [];
for i=1:N0
    SpkTime = HomoPoisSpkGenTaivo(30, 100, 0.1);
    spktimes_all = [spktimes_all; SpkTime];
end;

spktimes_all = sort(spktimes_all);
%plot(spktimes_all,'bx');

% Round spikes to nearest spiketime
spktimes_all = round(spktimes_all);



% ISI calculation
ISIs_sum=diff(spktimes_all);
bar(hist(ISIs_sum,30));
figure;
bar(log(hist(ISIs_sum,30)))