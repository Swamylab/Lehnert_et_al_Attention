function fa = extractFALickV2(trial, ti, L, dispFlag)

    if nargin == 3
        dispFlag = false;
    end

    sR = trial.stimulusRightType;
    sL = trial.stimulusLeftType;
    if trial.gratingContrast == 0 
        sL(sL == 'g') = 'n';
        sR(sR == 'g') = 'n';
    end
    l = trial.licksOnFrames;
    if length(sL) ~= length(sR) || length(sL) ~= length(l)
        error('length(sL) ~= length(sR)');
    end
    
    k = sR == 'n' & sL == 'n' & l == '.';
    noiseFrames(1:length(sR)) = '.';
    noiseFrames(k) = 'x';
    k = find(sR == 'g' | sL == 'g', 1);
    if ~isempty(k)
        noiseFrames(k : end) = '.';
    end
    
    startIndex = find(diff(noiseFrames == 'x') == 1) + 1;
    stopIndex = find(diff(noiseFrames == 'x') == -1);
 
    startStop(1 : length(sR)) = '.';
    startStop(startIndex) = '0';
    startStop(stopIndex) = '1';
    
    if dispFlag
        disp(' ');
        disp(' ');
        disp(trial.stimulusRightType);
        disp(trial.stimulusLeftType);
        disp(' ');
        disp(sR);
        disp(sL);
        disp(noiseFrames);
        disp(l);
        disp(startStop);
        xxx
    end
    
    if isempty(startIndex)
        disp(sR);
        disp(sL);
        disp(l);
        disp(noiseFrames);
        disp(startStop);
        error('isempty(startIndex)');
    end

    noiseFramesRevCor(1 : length(sR)) = '.';
    nIntervals = 0;
    for j = 1 : length(startIndex)
        k0 = startIndex(j);
        % what happen after the last pair of noise frames
        if j > length(stopIndex)
            % no stop index, thus the trial mst have ended
            if noiseFrames(end) ~= 'x'
                error('noiseFrames(end) ~= x');
            end
            k1 = length(noiseFrames);
        else
            k1 = stopIndex(j);
        end
        
        kk = k1+10;
        if kk > length(sR)
            kk = length(sR);
        end
        if k1 - k0 + 1 >= L
            % determine if there was a lick we need to include
            if k1 == length(noiseFrames)
                % trial ended early, thus no lick
                lickFlag = false;
                
            % is this the start of a grating and a FA lick occurred?

            elseif any(sR(k1+1 : kk) == 'g' | sL(k1+1 : kk) == 'g' | sR(k1+1 : kk) == 'f' | sL(k1+1 : kk) == 'f')
                if isnan(trial.rt)
                    error('isnan(trial.rt)');
                end
                if trial.rt <= .2
                    k1 = trial.hitLickFrame;
                    lickFlag = true;
                else
                    lickFlag = false;
                end
                
            % are we at a FA?
            elseif any(l(k1 : kk) == 'L')
                lickFlag = true;
                
            else
                disp('=================');
                disp(j);
                disp(sR);
                disp(sL);
                disp(l);
                disp(noiseFrames);
                disp(startStop);
                error(['Unknown lick flag k0 = ' num2str(k0) '  k1 = ' num2str(k1)]);
            end
            
            nIntervals = nIntervals + 1;
            fa(nIntervals).ti = ti;
            fa(nIntervals).li = nan;
            fa(nIntervals).firstStimIndexR = k0;
            fa(nIntervals).lastStimIndexR = k1;
            fa(nIntervals).firstStimIndexL = k0;
            fa(nIntervals).lastStimIndexL = k1;
            fa(nIntervals).lickFlag = lickFlag;
            noiseFramesRevCor(k0 : k1) = 'y';
            if lickFlag
                noiseFramesRevCor(k1) = 'L';
            end
        end
    end
    if dispFlag
        disp(noiseFramesRevCor);
    end
    if nIntervals == 0
        fa = [];
    end
end
