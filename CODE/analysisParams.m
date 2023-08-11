    clear pp;

    pp.numberOfPartitions = 3;
    pp.returnEnergyFlag = false;
    pp.verboseFlag = false;
    pp.fastGLMFlag = true;
    pp.P = 10;
    pp.rtList = 6 : 25;
    
    pp.mainEnergyPathName = '/media/swamylab/ErikData3Ex/FATA PAPER/DATA SECOND SUBMISSION';

    pp.orientationInc = 15;
    pp.cueOrientation = 'V';
    %pp.orientationList = 0: pp.orientationInc : 180-pp.orientationInc;
    pp.wavelengthInc = 9 / 12;
    pp.wavelengthList = 2 : pp.wavelengthInc : 11;
    pp.mirrorOrientationList = [165 150 135 120 105];
    pp.orientationsWithMirror = [15 30 45 60 75];
    pp.orientationList = [0 15 30 45 60 75 90];
    pp.spatialFreq = 1 ./ (2 * pp.wavelengthList);
    pp.orientation = [-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90];
    
    pp.minLickInterval = 1.5;
    pp.rowROI = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
    pp.colROI = [10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
    pp.spatialFlag = false;
    pp.numberOfPartitions = 3;
    pp.returnEnergyFlag = false;
    
    pp.verboseFlag = false;
    pp.fastGLMFlag = true;
    
    pp.P = 10;
    pp.sig = 6;
    pp.rtList = 6 : 25;
    pp.stimulusFrameInterval = 1/60;