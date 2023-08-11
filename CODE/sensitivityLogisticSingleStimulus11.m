function r = sensitivityLogisticSingleStimulus11(fa, eR, eL, p)
% Returns the the GLM object for the cued side and uncued side 
%
% fa is false alarm struct created with scanFALicks()
%
% eR and eL are stimulus energy. They can either by 3D arrays of full stimulus (3rd dim is time) or 1D vector. 
%
% p is parameters struct with fileds:
%
% p.ri and p.ci are the coordinates of the checker if a 3D eR and eL are
% passed.  You can also pass ci and ri explicitly.
%
% p.partitionNumber and p.numberOfPartitions tell us which partition to
% use. Set both to 1 to not use any partitions.  p.partitionNumber can be a
% list of partitions to use.
%
% p.rt is the reaction time (number of stimulus frames)
%
% p.P is the sampling interval (number of stimulus frames)
%
% p.verboseFlag displays size of design matrix
%
% p.fastGLMFlag is switch to use either fitglm (slow but returns glm
% model object) or glmfit (fast but returns only Bs)

    if isfield(p, 'fastGLMFlag')
        fastGLMFlag = p.fastGLMFlag;
    else
        fastGLMFlag = true;
    end 
    if isfield(p, 'returnEnergyFlag')
        returnEnergyFlag = p.returnEnergyFlag;
    else
        returnEnergyFlag = false;
    end 
    
    fai = 1 : length(fa);

    x = [];
    for k = 1 : length(p.partitionNumber)
        x = [x fai(p.partitionNumber(k) : p.numberOfPartitions : end)];
    end    
    fai = x;

    ti = fa(fai(1)).ti;
    if isempty(eR{ti})
        error('isempty(eR{ti})');
    end

    N = 0;
    lR = cell(length(fa),1);
    lL = cell(length(fa),1);
    for k = fai
        ti = fa(k).ti;
        if isempty(eR{ti}) || isempty(eL{ti})
            error('isempty(eR{ti}) || isempty(eL{ti})');
        end
        if fa(k).lastStimIndexR-fa(k).firstStimIndexR ~= fa(k).lastStimIndexL-fa(k).firstStimIndexL
            error('fa(k).lastStimIndexR-fa(k).firstStimIndexR ~= fa(k).lastStimIndexL-fa(k).lastStimIndexL');
        end
        i0 = fa(k).lastStimIndexR - p.rt;
        if i0 > 0
            lR{k} = i0 : -p.P : fa(k).firstStimIndexR;
            N = N + length(lR{k});
            i0 = fa(k).lastStimIndexL - p.rt;
            if i0 <= 0
                error('i0 <= 0');
            end
            lL{k} = i0 : -p.P : fa(k).firstStimIndexL;
        end
    end

    XCued = zeros(N,1);
    XUncued = zeros(N,1);
    Y = zeros(N,1);
    if returnEnergyFlag
        faIndex = zeros(N,1);
        tiOriginal = zeros(N,1);
    end

    j = 1;
    for k = fai
        ti = fa(k).ti;
        if ~isempty(lR{k})
            jR = lR{k};
            jL = lL{k};
            if length(jR) ~= length(jL)
                error('length(jR) ~= length(jL)');
            end
            if fa(k).cueSide == 'R'
                XCued(j : j+length(jR)-1) = eR{ti}(jR);
                XUncued(j : j+length(jL)-1) = eL{ti}(jL);
            else
                XCued(j : j+length(jL)-1) = eL{ti}(jL);
                XUncued(j : j+length(jR)-1) = eR{ti}(jR);
            end
            if fa(k).lickFlag
                Y(j) = 1;
            end
            if returnEnergyFlag
                faIndex(j : j+length(jL)-1) = k;
                tiOriginal(j : j+length(jL)-1) = fa(k).tiOriginal;
            end
            j = j + length(jR);
        end
    end
    if j-1 ~= N
        error('j-1 ~= N');
    end
    
    if p.verboseFlag
        disp(['     Size XCued = ' num2str(size(XCued)) '   size XUncued = ' num2str(size(XUncued)) '   size Y = ' num2str(size(Y))]);
    end
    if fastGLMFlag

        r.mdlCued.Coefficients.Estimate = glmfit(zscore(XCued),Y, 'binomial', 'Link','logit');
        r.mdlCued.Coefficients.N = length(Y);
        r.mdlUncued.Coefficients.Estimate = glmfit(zscore(XUncued),Y, 'binomial', 'Link','logit');
        r.mdlUncued.Coefficients.N = length(Y);
        
        if returnEnergyFlag
            r.XCued = XCued;
            r.XUncued = XUncued;
            r.Y = Y;
            r.faIndex = faIndex;
            r.tiOriginal = tiOriginal;
        end

    else

        r.mdlCued = fitglm(zscore(XCued),Y, 'Distribution', 'binomial', 'Link','logit');
        r.mdlUncued = fitglm(zscore(XUncued),Y, 'Distribution', 'binomial', 'Link','logit');

    end
end

%%


function [pLick, binnedE] = binPLick(X, Y, bw)

    x = sortrows([X Y]);
    j = 1;
    k = 1;
    pLick = [];  binnedE = [];
    while(1)
        if k+bw-1+bw < size(x,1)
            pLick(j) = sum(x(k : k+bw-1, 2)) / length(k : k+bw-1);
            binnedE(j) = mean(x(k : k+bw-1, 1));
            k = k + bw;
            j = j + 1;
        else
            pLick(j) = sum(x(k : end, 2)) / length(x(k : end, 2));
            binnedE(j) = mean(x(k : end, 1));
            break;
        end
    end
end
