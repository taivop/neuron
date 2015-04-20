function [spikes_binary, spiketimes] = ProbabilityOfRelease(p, sb, st)
    dt = 0.1;
    spikes_binary = zeros(size(sb));
    spiketimes = zeros(size(st));
    
    % For each synapse
    for j=1:size(st, 1)
        st_row_old = st(j,st(j,:)~=0);
        spikes_to_keep = rand(1, size(st_row_old, 2)) < p;
        
        % New spiketimes
        st_row_new = st_row_old(spikes_to_keep);
        % Pad with zeros
        st_row_new = [st_row_new zeros(1,size(st,2) - size(st_row_new, 2))];
        spiketimes(j,1:size(st_row_new, 2)) = st_row_new;
        
        % Rebuild spikes_binary matrix
        jthRow = st_row_new;

        for spktime=jthRow(jthRow ~= 0)
            spikes_binary(j,ceil(spktime:spktime+1/dt-1)) = 1;
        end
    end;
end