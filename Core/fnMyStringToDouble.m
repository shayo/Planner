function Result = fnMyStringToDouble(str)
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
%

% Converts a potential numeric string to a number (or array)
aiSep = find(str == ' ');
if isempty(aiSep)
    Tmp = str2double(str);
    if ~isnan(Tmp)
        Result = Tmp;
    else
        Result = [];
    end
    return;
end

% Need to split and handle each one:
aiParts = [0, aiSep, length(str)+1];
for k=1:length(aiParts)-1
    strPartial = str(aiParts(k)+1:aiParts(k+1)-1);
    Tmp = str2double(strPartial);
    if ~isnan(Tmp)
        Result(k) = Tmp;
    else
        Result = [];
        return;
    end
end
