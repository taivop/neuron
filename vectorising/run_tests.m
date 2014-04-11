numTests = 2; % How many tests do we have?
testsOK = [];
testsFailed = [];

fprintf('__________________\nRunning %d tests...\n', numTests);

for testNo=1:numTests

    % Generate an input matrix:
    in = load(sprintf('testdata/spk%d.mat',testNo));
    spktimes_all = in.spktimes_all;

    % Run both codes
    result_original = loop_original(spktimes_all);
    result_vectorised = loop_vectorised(spktimes_all);

    if result_original == result_vectorised
        testsOK = [testsOK testNo];
        fprintf('Test %02d: OK.\n', testNo);
    else
        testsFailed = [testsFailed testNo];
        fprintf('Test %02d: failed.\n', testNo);
    end;
end;

fprintf('Summary: success rate %.1f%%.\n', size(testsOK,2)/numTests*100);