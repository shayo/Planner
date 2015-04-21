function [acAttributes]=fnSplitString(strAttributes, charSep)
if ~exist('charSep','var')
    charSep = ';';
end
if isempty(strAttributes)
    acAttributes = cell(0);
    return;
end

if strAttributes(1) ~= charSep
    strAttributes = [charSep,strAttributes];
end

if strAttributes(end) ~= charSep
    strAttributes(end+1) = charSep;
end

aiSep = find(strAttributes == charSep);
acAttributes = cell(1, length(aiSep)-1);
for iIter=1:length(aiSep)-1
    acAttributes{iIter}=strAttributes(aiSep(iIter)+1:aiSep(iIter+1)-1);
end
return;