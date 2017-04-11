function AdjustTime
%ADJUSTTIME Summary of this function goes here
%   Detailed explanation goes here

% Reset MATLAB
close all
clear
clc

% Enable dependencies
[githubDir,~,~] = fileparts(pwd);
d12packDir      = fullfile(githubDir,'d12pack');
addpath(d12packDir);

% Map paths
timestamp = datestr(now,'yyyy-mm-dd_HHMM');

projectDir = '\\root\projects\Swedish-Healthy-Home-Hub\Arne-Lowden-Daysimeter-Data\batch 2';
dataDir = fullfile(projectDir,'croppedData');
saveDir = fullfile(projectDir,'adjustedData');
saveName  = [timestamp,'.mat'];
savePath  = fullfile(saveDir,saveName);

% Load data
objArray = loadData(dataDir);

% Specific adjustment amounts
adj = readtable('adjustmentTable.xlsx');
adj.Subject = cellfun(@num2str,num2cell(adj.Subject),'UniformOutput',false);

% Adjust time
nObj = numel(objArray);
for iObj = 1:nObj
    
    idxSub = strcmp(objArray(iObj).ID,adj.Subject);
    if ~any(idxSub)
        continue
    end
    
    objArray(iObj).ID = adj.AltSub{idxSub};
    dt = adj.Hours(idxSub);
    dt_dur = duration(dt,0,0);
    [h,m,s] = hms(dt_dur);
    
    thisLoginfo = objArray(iObj).log_info;
    newHour   = str2double(thisLoginfo(19:20))+h;
    newMinute = str2double(thisLoginfo(22:23))+m;
    if newMinute < 0
        newMinute = abs(newMinute);
        newHour   = newHour - 1;
    end
    thisLoginfo(19:20) = num2str(newHour,'%02d');
    thisLoginfo(22:23) = num2str(newMinute,'%02d');
    objArray(iObj).log_info = thisLoginfo;
    
    thisBedLog = objArray(iObj).BedLog;
    for iBed = 1:numel(thisBedLog)
        thisBedLog(iBed).BedTime = thisBedLog(iBed).BedTime + dt_dur;
        thisBedLog(iBed).RiseTime = thisBedLog(iBed).RiseTime + dt_dur;
    end
    objArray(iObj).BedLog = thisBedLog;
    
end

save(savePath,'objArray')

end

