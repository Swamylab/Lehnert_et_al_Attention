function [bs, bsDC] = computeKernel(mouseName, sessionList)

    disp(['     Computing kernel for mouse ' mouseName]);

    analysisParams;
    pp.mainEnergyPathName = '../DATA/ENERGY/';
    sessionRange = [11 40];

    faFN = [pp.mainEnergyPathName mouseName '_sessions' num2str(sessionRange(1)) 'to' num2str(sessionRange(2)) '_FA'];
   
    load(faFN);


    %sessionList = 29 : 40;

    fai = find(ismember(vertcat(fa.session), sessionList));
    if isempty(fai)
        error('No sessions');
    end

    bsDC = behavSenDCV1(mouseName, fa(fai), pp);
    bs = behavSenOriSFV1(mouseName, fa(fai), pp);
end
