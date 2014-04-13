numTests = 1000;
% Generate an input matrix:
in = load('testdata/spk1.mat');
spktimes_all = in.spktimes_all;
    

fprintf('Running original code...\n');
% start counter
start = cputime;
for testNo=1:numTests
    % Run test
    result_original = loop_original(spktimes_all);

end;
elapsedOriginal = cputime - start;
fprintf('Time spent: %.4fs.\n',elapsedOriginal);

fprintf('Running vectorised code...\n');
% start counter
start = cputime;
for testNo=1:numTests
    % Run test
    result_original = loop_original(spktimes_all);

end;
elapsedVectorised = cputime - start;
fprintf('Time spent: %.4fs.\n',elapsedVectorised);