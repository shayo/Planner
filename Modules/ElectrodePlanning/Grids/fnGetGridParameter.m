function Value = fnGetGridParameter(strctGridParams, strName)
for k=1:length(strctGridParams.m_acParam)
    if strcmpi(strctGridParams.m_acParam{k}.m_strName,strName)
        Value = strctGridParams.m_acParam{k}.m_Value;
        return;
    end;
end;
assert(false);
return;
