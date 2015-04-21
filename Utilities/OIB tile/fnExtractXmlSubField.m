function Value = fnExtractXmlSubField(Xml, strSubField)
for k=1:length(Xml.Children)
    if strcmpi(Xml.Children(k).Name, strSubField)
        T = str2num(Xml.Children(k).Children.Data);
        if ~isempty(T)
            Value = T;
        else
            Value = Xml.Children(k).Children.Data;
        end
        return;
    end
end
Value = [];
return;

