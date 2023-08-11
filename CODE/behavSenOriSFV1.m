function [bs, orientation, wavelength, orientationMirror] = behavSenOriSFV1(mouseName, fa, pp)
    
    faMirrorHasBeenSetFlag = false;
    
    orientation = nan(length(pp.wavelengthList), length(pp.orientationList));
    wavelength = nan(length(pp.wavelengthList), length(pp.orientationList));
    c = nan(length(pp.wavelengthList), length(pp.orientationList));

    for oi = 1 : length(pp.orientationList)
        for wi = 1 : length(pp.wavelengthList)
 
            orientation(wi, oi) = pp.orientationList(oi);
            wavelength(wi, oi) = pp.wavelengthList(wi);
            
            saveFN = [pp.mainEnergyPathName mouseName '_sessions' num2str(11) 'to' num2str(40) '_ori' num2str(orientation(wi, oi),3) '_wl' num2str(wavelength(wi, oi),3)];
            saveFN = strrep(saveFN,'..','**');
            saveFN = strrep(saveFN,'.','-');
            saveFN = strrep(saveFN,'**','..');
            disp(['     loading energy file ' saveFN]);
            load(saveFN);
            
            eR = gfsBRFR;
            eL = gfsBRFL;
            
            omi = find(pp.orientationsWithMirror == orientation(wi, oi));
            if ~isempty(omi)
                
                if not(faMirrorHasBeenSetFlag)
                    faMirror = fa;
                    numTrials = size(eR,1);
                    for k = 1 : length(faMirror)
                        faMirror(k).ti = faMirror(k).ti + numTrials;
                    end
                    
                    faMirrorHasBeenSetFlag = true;
                end
                
                orientationMirror(wi, oi) = pp.mirrorOrientationList(omi);
                saveFN = [pp.mainEnergyPathName '/' mouseName '_sessions' num2str(11) 'to' num2str(40) '_ori' num2str(orientationMirror(wi, oi),3) '_wl' num2str(wavelength(wi, oi),3)];
                saveFN = strrep(saveFN,'..','**');
                saveFN = strrep(saveFN,'.','-');
                saveFN = strrep(saveFN,'**','..');
                load(saveFN);

                if pp.verboseFlag
                    disp([mouseName '     o = ' num2str(orientation(wi, oi)) ' and ' num2str(orientationMirror(wi, oi)) '   w = ' num2str(wavelength(wi, oi))]);
                end
                bs(wi, oi) = partitionBehavioralSensitivity([fa faMirror], [eR ; gfsBRFR], [eL ; gfsBRFL], pp);
        
            else
                if pp.verboseFlag
                    disp([mouseName '     o = ' num2str(orientation(wi, oi)) '   w = ' num2str(wavelength(wi, oi))]);
                end
                bs(wi, oi) = partitionBehavioralSensitivity(fa, eR, eL, pp);
            end
            
        end
    end
end
            
            
            
%             %%
%     pp.colROI = [10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
%     pp.rowROI = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
%              
%     pp.orientationList = [0 15 30 45 60 75 90];
%     pp.mirrorOrientationList = [nan 165 150 135 120 105 nan];
%     pp.wavelengthList = [2 2.7500 3.5000 4.2500 5 5.7500 6.5000 7.2500 8 8.7500 9.5000 10.2500 11];
%     pp.spatialFlag = false;
%     clear sf bCued bUncued
%     for oi = 1 : length(p.orientationList)
%         for wi = 1 : length(p.wavelengthList)
%             sf(oi,wi) = 1 / (p.wavelengthList(wi)*2);
%         end
%     end
%     sf = flipud(sf');
% 
%     for si = 1 : 3
% 
%         fa = scanFALicks(trial, pp.trialList{si}, pp.minLickInterval, pp.L);
% 
%         faMirror = fa;
%         numTrials = max(horzcat(fa.ti));
%         for k = 1 : length(faMirror)
%             faMirror(k).ti = faMirror(k).ti + numTrials;
%         end
% 
%         bCued{si} = zeros(length(pp.orientationList), length(pp.wavelengthList));
%         bUncued{si} = zeros(length(pp.orientationList), length(pp.wavelengthList));
%         for oi = 1 : length(pp.orientationList)
%             for wi = 1 : length(pp.wavelengthList)
% 
%                 pp.orientation = pp.orientationList(oi);
%                 pp.wavelength = pp.wavelengthList(wi);
%                 disp(['Orientation = ' num2str(pp.orientation) '  wavelength = ' num2str(pp.wavelength)]);
%                 e = gaborFiltSmoothReadSave(pp.mouseName, pp.orientation, pp.wavelength, pp.sig, trial, fa, pp.rowROI, pp.colROI, pp.spatialFlag);
% 
%                 if ~isnan(pp.mirrorOrientationList(oi))
%                     pp.orientation = pp.mirrorOrientationList(oi);
%                     disp(['     Mirror orientation = ' num2str(pp.orientation) '  wavelength = ' num2str(pp.wavelength)]);
%                     eMirror = gaborFiltSmoothReadSave(pp.mouseName, pp.orientation, pp.wavelength, pp.sig, trial, faMirror, pp.rowROI, pp.colROI, pp.spatialFlag);
%                     disp('     Solving mirror');
%                     r = partitionBehavioralSensitivity([fa faMirror], [e.gfsBRFR ; eMirror.gfsBRFR], [e.gfsBRFL ; eMirror.gfsBRFL], pp);
%                 else
%                     disp('     Solving');
%                     r = partitionBehavioralSensitivity(fa, e.gfsBRFR, e.gfsBRFL, pp);
%                 end
%                 bCued{si}(oi, wi) = r.bCued;
%                 bUncued{si}(oi, wi) = r.bUncued;
%             end
%         end
% 
% 
%         bCuedFull = flipud(bCued{si}');
%         bCuedFull = [bCuedFull(:, end:-1:2) bCuedFull];
%         bUncuedFull = flipud(bUncued{si}');
%         bUncuedFull = [bUncuedFull(:, end:-1:2) bUncuedFull];
%         
% 
%             tic
%             rGaborBRF(wi, oi) = partitionBehavioralSensitivity(fa, gfsBRFR, gfsBRFL, pp);
%             disp(['     ' num2str(oi) ' ' num2str(wi) '  ' num2str(toc,3)]);
%         end
%     end


