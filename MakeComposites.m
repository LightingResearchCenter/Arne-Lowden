% Reset matlab
close all
clear
clc

dataDir = '\\root\projects\Swedish-Healthy-Home-Hub\Arne-Lowden-Daysimeter-Data\croppedData';
exportDir = '\\root\projects\Swedish-Healthy-Home-Hub\Arne-Lowden-Daysimeter-Data\composites';

% Load data
data = loadData(dataDir);

n  = numel(data);

timestamp = upper(datestr(now,'mmmdd'));

for iObj = 1:n
    thisObj = data(iObj);
    
    if isempty(thisObj.Time)
        continue
    end
    
    titleText = {'Arne Lowden - Stockholm';['ID: ',thisObj.ID,', Device SN: ',num2str(thisObj.SerialNumber)]};
    
    d = d12pack.composite(thisObj,titleText);
    
    d.Title = titleText;
    
    fileName = [thisObj.ID,'_',timestamp,'.pdf'];
    filePath = fullfile(exportDir,fileName);
    saveas(d.Figure,filePath);
    close(d.Figure);
end
