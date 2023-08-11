function bs = behavSenDCV1(mouseName, fa, pp)

    saveFN = [pp.mainEnergyPathName mouseName '_sessions' num2str(11) 'to' num2str(40) '_DC'];
    saveFN = strrep(saveFN,'..','**');
    saveFN = strrep(saveFN,'.','-');
    saveFN = strrep(saveFN,'**','..');
    disp(['     loading DC energy file ' saveFN]);
    load(saveFN);

    bs = partitionBehavioralSensitivity(fa, gfsBRFR, gfsBRFL, pp);

end

