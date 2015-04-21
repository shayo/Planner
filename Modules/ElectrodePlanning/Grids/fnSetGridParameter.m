function strctGridParams = fnSetGridParameter(strctGridParams, strName, Value)
for k=1:length(strctGridParams.m_acParam)
    if strcmpi(strctGridParams.m_acParam{k}.m_strName,strName)
        switch strctGridParams.m_acParam{k}.m_strType
            case 'Discrete'
                if ischar(Value)
                    Value = str2num(Value);
                end;
            case 'Logical'
                if ischar(Value)
                    Value = str2num(Value)>0;
                end;
            case 'Continuous'
                if ischar(Value)
                    Value = str2num(Value);
                end;
            case 'String'
                % Do nothing.
        end
        strctGridParams.m_acParam{k}.m_Value = Value;
        return;
    end;
end;
fprintf('WARNING! Failed to find field %s in grid sub model adjustments\n',strName);
return;
