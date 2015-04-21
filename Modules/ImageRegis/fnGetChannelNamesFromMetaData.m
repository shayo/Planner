function acChannelNames = fnGetChannelNamesFromMetaData(strMetaData)
acChannelNames = cell(0);
for iChannel=1:6
    acFields=fnSplitString(strMetaData,',');
    bFound = false;
    for k=1:length(acFields)
        if strfind(acFields{k},sprintf('[Channel %d Parameters] DyeName=',iChannel))
            acSplit = fnSplitString(acFields{k},'=');
            if length(acSplit)>1
                acChannelNames{iChannel} = acSplit{2};
                bFound = true;
            end
        end
    end
    if ~bFound
        return;
    end;
end
