% Main script to produce the reverse correaltion kernels for mouse 3590 shown in
% Figure 3B in Lehnert et al, Visual attention to features and space in mice 
% using reverse correlation (2023).
%
% Code developed on an 8-core 64GB Linux (Ubuntu) using MATLAB (R2020a) Update 1 with
% all toolboxes. Approximate run time is 15 hours and requires 2.5 GB
% of hard disk space to save stimulus energy.
%
% Contact erik.cook@mcgill.ca for questions about data and analysis code.

mouseName = '3590';
sessionList = 29 : 40;

cleanFlag = false;

%% Compute stimulus energy and save results

saveEnergySessions11To40(mouseName, cleanFlag)
saveDCEnergy(mouseName);

%% Compute kernels an save results

[bs, bsDC] = computeKernel(mouseName, sessionList);
fn = [mouseName '_kernels'];
save(fn, 'bs', 'bsDC');

%% Plot kernels for cued and uncued for this mouse.

clear all
mouseName = '3590';

analysisParams;
fn = [mouseName '_kernels'];
load(fn);

bCued = reshape(vertcat(bs.bCued), size(bs,1) , size(bs,2));
bCued = flipud([bCued(:, end : -1 : 2) bCued]);
bCued = [bsDC.bCued * ones(1, size(bCued,2)) ; bCued];
        
bUncued = reshape(vertcat(bs.bUncued), size(bs,1) , size(bs,2));
bUncued = flipud([bUncued(:, end : -1 : 2) bUncued]);
bUncued = [bsDC.bUncued * ones(1, size(bUncued,2)) ; bUncued];

figure(1);
clf;

mn = -.08;
mx = max([bCued(:) ; bUncued(:)]);
 
subplot(1,2,1);
imagesc(squeeze(bCued), [mn mx]);
set(gca, 'YDir', 'normal', 'TickLength', [.05 .05], 'TickDir', 'out');
set(gca, 'YTick', [1 2 8 14], 'YTickLabel', {'DC' num2str(pp.spatialFreq(13),2) num2str(pp.spatialFreq(7),2) num2str(pp.spatialFreq(1),2)});
set(gca, 'XTick', [1 7 13], 'XTickLabel', {num2str(pp.orientation(1),2) num2str(pp.orientation(7),2) num2str(pp.orientation(13),2)});
h = colorbar;
set(h, 'TickLength', .05, 'TickDir', 'out', 'Ticks', [mn 0 mx], 'TickLabels', {num2str(mn,2) 0 num2str(mx,2)});
axis tight;
axis square
title(['Mouse ' mouseName ' Cued']);
ylabel('Orientation (deg)');
xlabel('Spatal frequency (cpd)');

subplot(1,2,2);
imagesc(squeeze(bUncued), [mn mx]);
set(gca, 'YDir', 'normal', 'TickLength', [.05 .05], 'TickDir', 'out');
set(gca, 'YTick', [1 2 8 14], 'YTickLabel', {'DC' num2str(pp.spatialFreq(13),2) num2str(pp.spatialFreq(7),2) num2str(pp.spatialFreq(1),2)});
set(gca, 'XTick', [1 7 13], 'XTickLabel', {num2str(pp.orientation(1),2) num2str(pp.orientation(7),2) num2str(pp.orientation(13),2)});
h = colorbar;
set(h, 'TickLength', .05, 'TickDir', 'out', 'Ticks', [mn 0 mx], 'TickLabels', {num2str(mn,2) 0 num2str(mx,2)});
axis tight;
axis square
title(['Mouse ' mouseName ' Uncued']);
