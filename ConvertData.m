% Reset MATLAB
fclose('all');
close all
clear
clc

% Enable dependencies
addpath('C:\Users\jonesg5\Documents\GitHub\d12pack')
addpath('C:\Users\jonesg5\Documents\GitHub\circadian')

% Map file paths
rootDir = '\\root\projects';
calPath = fullfile(rootDir,'DaysimeterAndDimesimeterReferenceFiles',...
    'recalibration2016','calibration_log.csv');

projectDir = '\\root\projects\Swedish-Healthy-Home-Hub\Arne-Lowden-Daysimeter-Data\';
dataDir    = fullfile(projectDir,'original_daysimeter_data');

timestamp = datestr(now,'yyyy-mm-dd_HHMM');
dbName  = [timestamp,'.mat'];
dbPath  = fullfile(projectDir,'time_corrected_daysimeter_data',dbName);

datalogLs = dir(fullfile(dataDir,'*data.txt'));
datalogPaths = fullfile(dataDir,{datalogLs.name}');
loginfoPaths = regexprep(datalogPaths,'DATA\.txt','LOG.txt');
cdfPaths     = regexprep(datalogPaths,'-DATA\.txt','.cdf');

% Read start table
startTable = readStartTable;
% Extract subject IDs from start table
validIDList = startTable.id;

nFile = numel(datalogPaths);

for iFile = nFile:-1:1
    obj = d12pack.HumanData;
    
    % Read CDF data
    try
    cdfData = daysimeter12.readcdf(cdfPaths{iFile});
    catch err
        display(err)
    end
    
    % Add ID
    validID = correctID(cdfData.GlobalAttributes.subjectID, validIDList);
    obj.ID = validID;
    
    % Define calibration
    obj.CalibrationPath = calPath;
    obj.RatioMethod     = 'normal';
    
    % Define time zones
    obj.TimeZoneLaunch	= 'Europe/Stockholm';
    obj.TimeZoneDeploy	= 'Europe/Stockholm';
    
    % Import the original data
    obj.log_info = obj.readloginfo(loginfoPaths{iFile});
    obj.data_log = obj.readdatalog(datalogPaths{iFile});
    
    % Correct the start date and time
    [Lia,Locb] = ismember(obj.ID,startTable.id);
    if Lia
        correctStart = startTable.start_datetime(Locb);
        obj = correctTime(obj,correctStart);
    end
    
    % Add object to array of objects
    objArray(iFile,1) = obj;
end

% Save converted data to file
save(dbPath,'objArray');

