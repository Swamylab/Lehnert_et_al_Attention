function fa = adjustFAIndexesForRS(trial, fa)

% adjust for RS
    for k = 1 : length(fa)
        
        ti = fa(k).tiOriginal;
        if not(fa(k).firstStimIndexR == fa(k).firstStimIndexL) || not(fa(k).lastStimIndexR == fa(k).lastStimIndexL)
            error('first and last stim index do not agree');
        end
        if not(rem(fa(k).firstStimIndexR,2))
            i0 = fa(k).firstStimIndexR;
        else
            i0 = fa(k).firstStimIndexR + 1;
        end
        if trial(ti).gratingContrast == 0
            if not(trial(ti).stimulusRightType(i0) == 'n' || trial(ti).stimulusRightType(i0) == 'g') || ...
                    not(trial(ti).stimulusLeftType(i0) == 'n' || trial(ti).stimulusLeftType(i0) == 'g')
                N = 5;
                disp(trial(ti).stimulusRightType(i0-N : i0+N));
                disp(trial(ti).stimulusLeftType(i0-N : i0+N));
                disp(trial(ti).licksOnFrames(i0-N : i0+N));
                error('Frst frame type not n');
            end
        else
            if not(trial(ti).stimulusRightType(i0) == 'n') || not(trial(ti).stimulusLeftType(i0) == 'n')
                N = 5;
                disp(trial(ti).stimulusRightType(i0-N : i0+N));
                disp(trial(ti).stimulusLeftType(i0-N : i0+N));
                disp(trial(ti).licksOnFrames(i0-N : i0+N));
                error('Frst frame type not n');
            end
        end
        if not(rem(fa(k).lastStimIndexR,2))
            i1 = fa(k).lastStimIndexR;
        else
            i1 = fa(k).lastStimIndexR - 1;
        end
        if not(trial(ti).stimulusRightType(i1) == 'n' || trial(ti).stimulusRightType(i1) == 'g' || trial(ti).stimulusRightType(i1) == 'f') || ...
                not(trial(ti).stimulusLeftType(i1) == 'n' || trial(ti).stimulusLeftType(i1) == 'g' || trial(ti).stimulusLeftType(i1) == 'f')
            error('last frame type not n or g or f');
        end 
        fa(k).firstStimIndexR60Hz = fa(k).firstStimIndexR;
        fa(k).lastStimIndexR60Hz = fa(k).lastStimIndexR;
        fa(k).firstStimIndexL60Hz = fa(k).firstStimIndexR;
        fa(k).lastStimIndexL60Hz = fa(k).lastStimIndexR;
        fa(k).firstStimIndexR = i0/2;
        fa(k).lastStimIndexR = i1/2;
        fa(k).firstStimIndexL = i0/2;
        fa(k).lastStimIndexL = i1/2;
    end
end