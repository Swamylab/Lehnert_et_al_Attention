function fa = scanFALicksV2(trial, trialList, minLickInterval, stimulusFrameInterval)

    L = round(minLickInterval / stimulusFrameInterval);
    disp(['     Scanning FA licks for mouse ' trial(1).mouseName '  min lick interval (sec) = ' num2str(minLickInterval) '  min number of stimulus frames = ' num2str(L)]);
    fa = [];
    trialIndex = 0;
    nFramesR = 0;
    nFramesL = 0;
    for j = 1 : length(trialList)
        ti = trialList(j);
        x = extractFALickV2(trial(ti), ti, L);
        if ~isempty(x)
            trialIndex = trialIndex + 1;
            for li = 1 : length(x)
                x(li).tiOriginal = x(li).ti;
                x(li).ti = trialIndex;
                x(li).cueOrientation = trial(ti).cueOrientation;
                x(li).gratingOrientation = trial(ti).gratingOrientation;
                x(li).cueSide = trial(ti).cueSide;
                x(li).gratingSide = trial(ti).gratingSide;
                if x(li).gratingSide == x(li).cueSide
                    x(li).validCue = true;
                else
                    x(li).validCue = false;
                end
                x(li).session = trial(ti).session;
                x(li).fileName = trial(ti).fileName;
                x(li).rt = trial(ti).rt;
                x(li).gratingContrast = trial(ti).gratingContrast;
                x(li).gratingOnFrame = trial(ti).gratingOnFrame;
                x(li).hitLickFrame = trial(ti).hitLickFrame;
                nFramesR = nFramesR + x(li).lastStimIndexR - x(li).firstStimIndexR + 1;
                nFramesL = nFramesL + x(li).lastStimIndexL - x(li).firstStimIndexL + 1;
                fa = [fa x(li)];
            end
        end
    end
    if ~isempty(fa)
        disp(['     ' num2str(length(fa)) ' noise intervals   trials with intervals = ' num2str(length(unique(vertcat(fa.tiOriginal)))) ' of trials scanned = ' num2str(length(trialList)) '    nFramesR = ' num2str(nFramesR) '   nFramesL = ' num2str(nFramesL)]);
    else
        disp('      No FA licks');
    end
end