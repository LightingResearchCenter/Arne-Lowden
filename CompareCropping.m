% Reset MATLAB
close all
clear
clc

% Enable dependencies
[githubDir,~,~] = fileparts(pwd);
d12packDir      = fullfile(githubDir,'d12pack');
addpath(d12packDir);

% Map paths
gregDir  = '\\root\public\jonesg5\Cropping Comparison\Greg';
geoffDir = '\\root\public\jonesg5\Cropping Comparison\Geoff';
exportDir = '\\root\public\jonesg5\Cropping Comparison\Daysigrams';

% Load data
dataGeoff = loadData(gregDir);
dataGreg  = loadData(geoffDir);

% Select first 10 data sets, discard rest
dataGeoff(11:end) = [];
dataGreg(11:end)  = [];

% Perform analysis
analysisGeoff = analysis(dataGeoff);
analysisGreg  = analysis(dataGreg);

% Select only relevent analysis results
analysisGeoff = analysisGeoff(:,[2,12:16]);
analysisGreg  = analysisGreg(:,[2,12:16]);

% Remove row 3 because it is empty
analysisGeoff(3,:) = [];
analysisGreg(3,:)  = [];

% Plot comparison of results
figure
x = (1:9)';

ax = subplot(5,1,1);
plot(x, analysisGeoff.Phasor_Coverage_Days, '+');
hold on
plot(x, analysisGreg.Phasor_Coverage_Days,  'x');
title('Phasor Coverage (days)')
legend('Cropped by Geoff','Cropped by Greg','Location','northeastoutside')
ax.XLim = [0.5,9.5];
ax.XTick = x;
ax.XTickLabel = analysisGeoff.ID;
ax.Box = 'off';
ax.YGrid = 'on';
ax.XGrid = 'on';
ax.TickDir = 'out';
delta = analysisGeoff.Phasor_Coverage_Days - analysisGreg.Phasor_Coverage_Days;
yDelta = analysisGreg.Phasor_Coverage_Days + delta/2;
deltaText = cellfun(@(c)num2str(c,2),num2cell(delta),'UniformOutput',false);
text(x+0.05,yDelta,deltaText)

ax = subplot(5,1,2);
plot(x, analysisGeoff.Phasor_Magnitude, '+');
hold on
plot(x, analysisGreg.Phasor_Magnitude,  'x');
title('Phasor Magnitude')
legend('Cropped by Geoff','Cropped by Greg','Location','northeastoutside')
ax.XLim = [0.5,9.5];
ax.XTick = x;
ax.XTickLabel = analysisGeoff.ID;
ax.Box = 'off';
ax.YGrid = 'on';
ax.XGrid = 'on';
ax.TickDir = 'out';
delta = analysisGeoff.Phasor_Magnitude - analysisGreg.Phasor_Magnitude;
yDelta = analysisGreg.Phasor_Magnitude + delta/2;
deltaText = cellfun(@(c)num2str(c,2),num2cell(delta),'UniformOutput',false);
text(x+0.05,yDelta,deltaText)

ax = subplot(5,1,3);
plot(x, analysisGeoff.Phasor_Angle_Hours, '+');
hold on
plot(x, analysisGreg.Phasor_Angle_Hours,  'x');
title('Phasor Angle (hours)')
legend('Cropped by Geoff','Cropped by Greg','Location','northeastoutside')
ax.XLim = [0.5,9.5];
ax.XTick = x;
ax.XTickLabel = analysisGeoff.ID;
ax.Box = 'off';
ax.YGrid = 'on';
ax.XGrid = 'on';
ax.TickDir = 'out';
delta = analysisGeoff.Phasor_Angle_Hours - analysisGreg.Phasor_Angle_Hours;
yDelta = analysisGreg.Phasor_Angle_Hours + delta/2;
deltaText = cellfun(@(c)num2str(c,2),num2cell(delta),'UniformOutput',false);
text(x+0.05,yDelta,deltaText)

ax = subplot(5,1,4);
plot(x, analysisGeoff.InterdailyStability, '+');
hold on
plot(x, analysisGreg.InterdailyStability,  'x');
title('Interdaily Stability')
legend('Cropped by Geoff','Cropped by Greg','Location','northeastoutside')
ax.XLim = [0.5,9.5];
ax.XTick = x;
ax.XTickLabel = analysisGeoff.ID;
ax.Box = 'off';
ax.YGrid = 'on';
ax.XGrid = 'on';
ax.TickDir = 'out';
delta = analysisGeoff.InterdailyStability - analysisGreg.InterdailyStability;
yDelta = analysisGreg.InterdailyStability + delta/2;
deltaText = cellfun(@(c)num2str(c,2),num2cell(delta),'UniformOutput',false);
text(x+0.05,yDelta,deltaText)

ax = subplot(5,1,5);
plot(x, analysisGeoff.IntradailyVariability, '+');
hold on
plot(x, analysisGreg.IntradailyVariability,  'x');
title('Intradaily Variability')
legend('Cropped by Geoff','Cropped by Greg','Location','northeastoutside')
ax.XLim = [0.5,9.5];
ax.XTick = x;
ax.XTickLabel = analysisGeoff.ID;
ax.Box = 'off';
ax.YGrid = 'on';
ax.XGrid = 'on';
ax.TickDir = 'out';
delta = analysisGeoff.IntradailyVariability - analysisGreg.IntradailyVariability;
yDelta = analysisGreg.IntradailyVariability + delta/2;
deltaText = cellfun(@(c)num2str(c,2),num2cell(delta),'UniformOutput',false);
text(x+0.05,yDelta,deltaText)

timestamp = upper(datestr(now,'mmmdd'));

for iObj = 1:numel(dataGeoff)
    thisObj = dataGeoff(iObj);
    
    if isempty(thisObj.Time)
        continue
    end
    
    titleText = {'Cropped by Geoff';['ID: ',thisObj.ID,', Device SN: ',num2str(thisObj.SerialNumber)]};
    
    d = d12pack.daysigram(thisObj,titleText);
    
    for iFile = 1:numel(d)
        d(iFile).Title = titleText;
        
        fileName = ['GEOFF_',thisObj.ID,'_',timestamp,'_p',num2str(iFile),'.pdf'];
        filePath = fullfile(exportDir,fileName);
        saveas(d(iFile).Figure,filePath);
        close(d(iFile).Figure);
        
    end
end

for iObj = 1:numel(dataGreg)
    thisObj = dataGreg(iObj);
    
    if isempty(thisObj.Time)
        continue
    end
    
    titleText = {'Cropped by Greg';['ID: ',thisObj.ID,', Device SN: ',num2str(thisObj.SerialNumber)]};
    
    d = d12pack.daysigram(thisObj,titleText);
    
    for iFile = 1:numel(d)
        d(iFile).Title = titleText;
        
        fileName = ['GREG_',thisObj.ID,'_',timestamp,'_p',num2str(iFile),'.pdf'];
        filePath = fullfile(exportDir,fileName);
        saveas(d(iFile).Figure,filePath);
        close(d(iFile).Figure);
        
    end
end