function validID = correctID(existingID, validIDList)
%CORRECTID Summary of this function goes here
%   Detailed explanation goes here

% Remove underscores
strippedIDList = regexprep(validIDList,'_','');
strippedID = regexprep(existingID,'_','');

% Find matching ID
[Lia, Locb] = ismember(strippedID, strippedIDList);

% Return properly formatted version if there is a match
if Lia
    validID = validIDList{Locb};
else
    validID = existingID;
    warning(['No matching ID found for: ',existingID,'.'])
end

end

