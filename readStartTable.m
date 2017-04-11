function T = readStartTable
%READSTARTTABLE Summary of this function goes here
%   Detailed explanation goes here

% Define file path
filePath = '\\root\projects\Swedish-Healthy-Home-Hub\Arne-Lowden-Daysimeter-Data\id_start_GO.xlsx';

% Read file
T = readtable(filePath);

% Combine date and hour
T.start_datetime = T.start_date + duration(24*T.start_hour,0,0);
% Remove date and hour
T.start_date = [];
T.start_hour = [];
% Format datetime
T.start_datetime.Format = 'default';
% Set time zone
T.start_datetime.TimeZone = 'Europe/Stockholm';

end

