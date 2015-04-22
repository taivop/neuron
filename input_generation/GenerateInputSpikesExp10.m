function [spikes_binary, spiketimes] = GenerateInputSpikesExp10(exp, T0, dt, ~)

    % Get spike trains
    [sb, st] = GenerateInputSpikesUncorrelated(50, exp.rate1, T0, dt, '');
    [sb2, st2] = GenerateInputSpikesUncorrelated(50, exp.rate2, T0, dt, '');
    
    % Concatenate
    spikes_binary = vertcat(sb, sb2);
    
    % pad t1 or t2 with zeros to vertcat them
    if size(st, 2) > size(st2, 2)
        % need to pad t2
        pad_extent = abs(size(st, 2) - size(st2, 2));
        st2 = [st2 zeros(size(st2,1), pad_extent)];
    elseif size(st, 2) < size(st2, 2)
        % need to pad t1
        pad_extent = abs(size(st, 2) - size(st2, 2));
        st = [st zeros(size(st,1), pad_extent)];
    end;

    spiketimes = vertcat(st, st2);
end










