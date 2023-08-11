function [fa, gfsBRFR, gfsBRFL, gfsResizeR, gfsResizeL] = gaborFilterStimV2OriginalRS(trial, fa, g, sig, spaceOrBRF, rowROI, colROI)

    numTrials = length(unique(horzcat(fa.ti)));

    disp(['     Filtering stimulus for mouse ' trial(1).mouseName '  sigma = ' num2str(sig) '  number of trials = ' num2str(numTrials)]);
    
    if not(ismember(spaceOrBRF, {'brf' 'both' 'space'}))
        error('bad spaceOrBRF');
    end

    stimR = cell(numTrials,1);
    stimL = cell(numTrials,1);
    gfsR = cell(numTrials,1);
    gfsL = cell(numTrials,1);
    stR = cell(numTrials,1);
    stL = cell(numTrials,1);
    gc = zeros(numTrials,1);
    nr = size(trial(1).checkerboardStimRight,1);
    nc = size(trial(1).checkerboardStimRight,2);
    tiLast = 0;
    k = 0;
    for j = 1 : length(fa)
        ti = fa(j).ti;
        if ti ~= tiLast
            k = k + 1;
            tiOriginal = fa(j).tiOriginal;

            % adjust stimulus
            % convert to -128 = black, 127 = black and gray = 0
            if islogical(trial(tiOriginal).checkerboardStimRight)
                % Jonas stim
                stimR{k} = int8(trial(tiOriginal).checkerboardStimRight);
                stimL{k} = int8(trial(tiOriginal).checkerboardStimLeft);
                
                stimR{k}(stimR{k} == 1) = 127;
                stimL{k}(stimL{k} == 1) = 127;
                stimR{k}(stimR{k} == 0) = -128;
                stimL{k}(stimL{k} == 0) = -128;
            else
                % Checkerboards have gray scales 0 to 255 stored as uint8.
                % We need to cast as 16 bit before we subtract the 128 gray.
                stimR{k} = int8(int16(trial(tiOriginal).checkerboardStimRight) - 128);
                stimL{k} = int8(int16(trial(tiOriginal).checkerboardStimLeft) - 128);
            end  
            stR{k} = trial(tiOriginal).stimulusRightType;
            stL{k} = trial(tiOriginal).stimulusLeftType;
            gc(k) = trial(tiOriginal).gratingContrast;
%             if nargout > 2
%                 trialStruct(k).fileName = trial(tiOriginal).fileName;
%                 trialStruct(k).tiOriginal = tiOriginal;
%             end
        end
        tiLast = ti;
    end
    if k ~= numTrials
        error('k ~= numTrials');
    end

    parfor j = 1 : numTrials
        sR = stimR{j};
        if gc(j) > 0
            k = ~(stR{j} == 'n');
        else
            k = ~(stR{j} == 'n' | stR{j} == 'g');
        end
        sR(:,:,k) = randomCheckerFrames(nr,nc,sum(k));

        sL = stimL{j};
        if gc(j) > 0
            k = ~(stL{j} == 'n');
        else
            k = ~(stL{j} == 'n' | stL{j} == 'g');
        end
        sL(:,:,k) = randomCheckerFrames(nr,nc,sum(k));

        nPad = ceil(5*sig);
        
        stimR{j} = cat(3, randomCheckerFrames(nr,nc,nPad), sR, randomCheckerFrames(nr,nc,nPad));
        if sig > 0
            x = single(gaussSmoothD3(gaborFilterStimulus(stimR{j}, g), sig));
        else
            x = single(gaborFilterStimulus(stimR{j}, g));
        end
        %gfsR{j} = x(:,:,nPad+1:end-nPad);
        gfsR{j} = x(:,:,nPad+1+1: 2 : end-nPad);
        
        stimL{j} = cat(3, randomCheckerFrames(nr,nc,nPad), sL, randomCheckerFrames(nr,nc,nPad));
        if sig > 0
            x = single(gaussSmoothD3(gaborFilterStimulus(stimL{j}, g), sig));
        else
            x = single(gaborFilterStimulus(stimL{j}, g)); 
        end
        %gfsL{j} = x(:,:,nPad+1:end-nPad);
        gfsL{j} = x(:,:,nPad+1+1: 2 : end-nPad);
    end
    
    % adjust indexes for RS of 2
    fa = adjustFAIndexesForRS(trial, fa);
  
    nr = size(trial(1).checkerboardStimRight,1);
    nc = size(trial(1).checkerboardStimRight,2);
    
    if ismember(spaceOrBRF, {'brf' 'both'})
        gfsBRFR = cell(length(gfsR),1);
        gfsBRFL = cell(length(gfsL),1);
        behavioralRfMask = false(nr,nc);
        behavioralRfMask(rowROI, colROI) = true;
        for k = 1 : length(gfsR)
            gfsBRFR{k} = reshape(sum(gfsR{k} .* behavioralRfMask, [1 2]), [1 size(gfsR{k},3)]);
            gfsBRFL{k} = reshape(sum(gfsL{k} .* behavioralRfMask, [1 2]), [1 size(gfsL{k},3)]);
        end
    end

    if ismember(spaceOrBRF, {'space' 'both'})
        gfsResizeR = cell(nr*nc, 1);
        gfsResizeL = cell(nr*nc, 1);
        for k = 1 : nr*nc
            gfsResizeR{k} = {};
            gfsResizeL{k} = {};
        end
        for ti = 1 : length(gfsR)
            k = 1;
            for ri = 1 : nr
                for ci = 1 : nc
                    gfsResizeR{k} = [gfsResizeR{k} squeeze(gfsR{ti}(ri,ci,:))];
                    gfsResizeL{k} = [gfsResizeL{k} squeeze(gfsL{ti}(ri,ci,:))];
                    k = k + 1;
                end
            end
            gfsR{ti} = [];
            gfsL{ti} = [];
        end 
    %     for ri = 1 : nr
    %         for ci = 1 : nc
    %             gfsResizeR{k} = {};
    %             gfsResizeL{k} = {};
    %             for ti = 1 : length(gfsR)
    %                 gfsResizeR{k} = [gfsResizeR{k} squeeze(gfsR{ti}(ri,ci,:))];
    %                 gfsResizeL{k} = [gfsResizeL{k} squeeze(gfsL{ti}(ri,ci,:))];
    %             end
    %             k = k + 1;
    %         end
    %     end 
    end
    if(~exist('gfsBRFR', 'var'))
        gfsBRFR = [];
    end
    if(~exist('gfsBRFL', 'var'))
        gfsBRFL = [];
    end
    if(~exist('gfsResizeR', 'var'))
        gfsResizeR = [];
    end
    if(~exist('gfsResizeL', 'var'))
        gfsResizeL = [];
    end
end

function x = randomCheckerFrames(nr,nc,n)
    x = int8((rand(nr, nc, n) > 0.5) * 255 - 128);
end