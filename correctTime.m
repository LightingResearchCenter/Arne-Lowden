function obj = correctTime(obj,correctStart)
%CORRECTTIME Correct log_info start date and time
%   obj is a DaysimeterData class (or child class) object
%   correctStart is datetime Daysimeter was started on

% Convert datetime to formatted string
correctStartStr = datestr(correctStart,'mm-dd-yy HH:MM');

% Replace start date time characteres in log_info
obj.log_info(10:23) = correctStartStr;

end

