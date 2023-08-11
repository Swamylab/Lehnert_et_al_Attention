function r = partitionBehavioralSensitivity(fa, gfsR, gfsL, pp, ri, ci)

    if nargin > 4
        pp.ri = ri;
        pp.ci = ci;
    end

    for testPartitionNumber = 1 : pp.numberOfPartitions
        
        trainParitionNumbers = 1 : pp.numberOfPartitions;
        trainParitionNumbers(testPartitionNumber) = [];
        
        % estimate RT from train partitions
        pp.partitionNumber = trainParitionNumbers;
        bCued = zeros(1, length(pp.rtList));
        bUncued = zeros(1, length(pp.rtList));
        kCued = zeros(1, length(pp.rtList));
        kUncued = zeros(1, length(pp.rtList));
        for rti = 1 : length(pp.rtList)
            pp.rt = pp.rtList(rti);
            rr = sensitivityLogisticSingleStimulus11(fa, gfsR, gfsL, pp);
            bCued(rti) = rr.mdlCued.Coefficients.Estimate(2);
            bUncued(rti) = rr.mdlUncued.Coefficients.Estimate(2);
            kCued(rti) = rr.mdlCued.Coefficients.Estimate(1);
            kUncued(rti) = rr.mdlUncued.Coefficients.Estimate(1);
        end
        
        % estimate B from test partition
        pp.partitionNumber = testPartitionNumber;
        % b cued
        [~, rti] = max(abs(bCued)); % abs because either sign is important
        pp.rt = pp.rtList(rti);
        r.rtCuedPartition(testPartitionNumber) = pp.rt;
        rr = sensitivityLogisticSingleStimulus11(fa, gfsR, gfsL, pp);
        r.bCuedPartition(testPartitionNumber) = rr.mdlCued.Coefficients.Estimate(2);
        r.kCuedPartition(testPartitionNumber) = rr.mdlCued.Coefficients.Estimate(1);
        r.NCuedPartition(testPartitionNumber) = rr.mdlCued.Coefficients.N;
        if pp.fastGLMFlag == false
            r.bCuedPartitionFullStruct(testPartitionNumber) = rr;
        end
        
        % b uncued
        [~, rti] = max(abs(bUncued));
        pp.rt = pp.rtList(rti);
        r.rtUncuedPartition(testPartitionNumber) = pp.rt;
        rr = sensitivityLogisticSingleStimulus11(fa, gfsR, gfsL, pp);
        r.bUncuedPartition(testPartitionNumber) = rr.mdlUncued.Coefficients.Estimate(2);
        r.kUncuedPartition(testPartitionNumber) = rr.mdlUncued.Coefficients.Estimate(1);
        r.NUncuedPartition(testPartitionNumber) = rr.mdlUncued.Coefficients.N;
        if pp.fastGLMFlag == false
            r.bUncuedPartitionFullStruct(testPartitionNumber) = rr;
        end
    end
    r.bCued = mean(horzcat(r.bCuedPartition));
    r.bUncued = mean(horzcat(r.bUncuedPartition));
    r.kCued = mean(horzcat(r.kCuedPartition));
    r.kUncued = mean(horzcat(r.kUncuedPartition));
    r.rtCued = mean(horzcat(r.rtCuedPartition));
    r.rtUncued = mean(horzcat(r.rtUncuedPartition));
    r.NCued = sum(horzcat(r.NCuedPartition));
    r.NUncued = sum(horzcat(r.NUncuedPartition));
end