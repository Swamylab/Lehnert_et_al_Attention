function saveEnergySessions11To40(mouseName, cleanFlag)


    if nargin == 1
        cleanFlag = true;
    end
    mainDataPathName = '../DATA/MICE/';
    mainEnergyPathName = '../DATA/ENERGY/';

    fn = [mainDataPathName mouseName '_extracted_small_nocomp'];

    delete(gcp('nocreate'));
    clear trial
    disp(['     Loading ' fn]);
    load(fn);
 
    pp.sessionRange = [11 40];
    
    pp.mouseName = mouseName;
    pp.orientationInc = 15;
    pp.cueOrientation = 'V';
    pp.orientationList = 0: pp.orientationInc : 180-pp.orientationInc;
    pp.wavelengthInc = 9 / length(pp.orientationList);
    pp.wavelengthList = 2 : pp.wavelengthInc : 11;
    
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
    
    pp.trialList = find(horzcat(trial.session) >= pp.sessionRange(1) & horzcat(trial.session) <= pp.sessionRange(2) & ...
        horzcat(trial.requireBehavior) & horzcat(trial.noiseAmplitude) == 1 & ...
        not(horzcat(trial.stimError)) & not(isnan(horzcat(trial.rt))));
    
    faOriginal = scanFALicksV2(trial, pp.trialList, pp.minLickInterval, pp.stimulusFrameInterval);

    %% Orientation and wavelength
    disp('     Computing energy of all checkerboards.  This may take many hours');

    for oi = 1 : length(pp.orientationList)
        for wi = 1 : length(pp.wavelengthList)
            
            pp.orientation = pp.orientationList(oi);
            pp.wavelength = pp.wavelengthList(wi);
            
            disp(['     Orientation = ' num2str(pp.orientation) '  wavelength = ' num2str(pp.wavelength) ' for mouse ' mouseName]);
            
            
            saveFN = [mainEnergyPathName mouseName '_sessions' num2str(pp.sessionRange(1)) 'to' num2str(pp.sessionRange(2)) '_ori' num2str(pp.orientation,3) '_wl' num2str(pp.wavelength,3)];
            saveFN = strrep(saveFN,'..','**');
            saveFN = strrep(saveFN,'.','-');
            saveFN = strrep(saveFN,'**','..');
            
            disp(['     Energy file name = ' saveFN]);
   
            skipFlag = false;
            if ~cleanFlag
                if exist([saveFN '.mat'], 'file')
                    skipFlag = true;
                    disp(['     File already exists skipping ' saveFN]);
                end
            end
            if ~skipFlag
                disp(['     Filtering ' num2str(pp.orientation,3) ' ' num2str(pp.wavelength,3)]);
        
                gabor.gaborSigmaX = [];
                gabor.width = 26;
                gabor.gaborSigmaY = 4;
                gabor.gaborSigmaYScale = [];
                gabor.spatialFrequencyBandwidth = 1;
                gabor.matlabGaborFlag = false;
                gabor.orientation = pp.orientation;
                gabor.wavelength = pp.wavelength;
                gabor.gaborFilt = gaborFilt(gabor.orientation, gabor.wavelength, gabor.gaborSigmaX, gabor.gaborSigmaY, gabor.gaborSigmaYScale, gabor.width);
                                
                [fa, gfsBRFR, gfsBRFL] = gaborFilterStimV2OriginalRS(trial, faOriginal, gabor.gaborFilt, pp.sig, 'brf', pp.rowROI, pp.colROI);
                
                if oi == 1 && wi == 1
                    faFN = [mainEnergyPathName '/' mouseName '_sessions' num2str(pp.sessionRange(1)) 'to' num2str(pp.sessionRange(2)) '_FA'];
                    disp(['     saving FA to ' faFN]);
                    save(faFN, 'fa', '-v7.3', '-nocompression');
                end
                disp(['     saving energy to ' saveFN]);
                save(saveFN, 'gfsBRFR', 'gfsBRFL', '-v7.3', '-nocompression');
            end
        end
    end
end

