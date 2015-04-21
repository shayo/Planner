function strctConfig = fnMyXMLToStruct(strXMLFile,bWarning)
global g_bWarning 
if ~exist('bWarning','var')
    g_bWarning = true;
end;
strctRAW = xml2struct(strXMLFile);
strctConfig = fnRecursiveParse(strctRAW,[],'strctConfig');
clear global g_bWarning 
return;


function strctConfig = fnRecursiveParse(strctRAW,strctConfig,strRoot)
iNumElements = length(strctRAW);

for iElementIter=1:iNumElements
    if strcmpi(strctRAW(iElementIter).Name,'#comment')  || strcmpi(strctRAW(iElementIter).Name,'#text')
        continue;
    end;
    
    iNumAttributes = length(strctRAW(iElementIter).Attributes);
    if iNumAttributes > 0
        % Add attributes
        strctTmp = [];
        for iAttributeIter=1:iNumAttributes
            strFieldName = strctRAW(iElementIter).Attributes(iAttributeIter).Name;
            switch fnMyClass(strFieldName)
                case 'double'
                    FieldValue = fnMyStringToDouble(strctRAW(iElementIter).Attributes(iAttributeIter).Value);
                case 'boolean'
                    FieldValue = fnMyStringToDouble(strctRAW(iElementIter).Attributes(iAttributeIter).Value) > 0;
                case 'string'
                    FieldValue = strctRAW(iElementIter).Attributes(iAttributeIter).Value;
            end
            strctTmp = setfield(strctTmp,strFieldName,FieldValue);
        end
      %  fprintf('Adding %s\n',strctRAW(iElementIter).Name);
        eval([strRoot,' = strctTmp;';]);
    end
    
    iNumChildren = length(strctRAW(iElementIter).Children);
    if iNumChildren > 0
        for iChildIter=1:iNumChildren
            if strcmpi(strctRAW(iElementIter).Children(iChildIter).Name,'#text') || strcmpi(strctRAW(iElementIter).Children(iChildIter).Name,'#comment') 
                continue;
            end
            Tmp = eval(strRoot);
            strSubFieldName = strctRAW(iElementIter).Children(iChildIter).Name;
            
            strPostfix = '';
            if isfield(Tmp, strSubFieldName)
                [strctConfig,strPostfix] = fnDuplicateEntriesFix(strctConfig,strSubFieldName,strRoot);
            end
            
            strSubFieldNameFull = [strRoot,'.',strSubFieldName,strPostfix];
            eval([strSubFieldNameFull,' = [];']);
            strctConfig = fnRecursiveParse(strctRAW(iElementIter).Children(iChildIter),strctConfig,strSubFieldNameFull);
    
        end
    end
    
end

function [strctConfig,strPostfix] = fnDuplicateEntriesFix(strctConfig,strSubFieldName,strRoot)

Tmp = eval(strRoot);
TmpInside = getfield(Tmp,strSubFieldName);
if iscell(TmpInside)
    iLen = length(TmpInside);
    strPostfix = ['{',num2str(iLen+1),'}'];
else
    % Change to cell array
    eval([strRoot,' = rmfield(Tmp,''',strSubFieldName,''');']);
    eval([strRoot,'.', strSubFieldName,'{1} = TmpInside;';]);
    strPostfix = '{2}';
end
return



function strClass = fnMyClass(strFieldName)
global g_bWarning 

if strncmpi(strFieldName,'m_ai',4) || strncmpi(strFieldName,'m_af',4) || strncmpi(strFieldName,'m_i',3) || strncmpi(strFieldName,'m_f',3) 
    strClass  = 'double';
elseif strncmpi(strFieldName,'m_b',3) 
    strClass  = 'boolean';
elseif strncmpi(strFieldName,'m_str',5) 
    strClass  = 'string';
else
    if g_bWarning
        fprintf('Unknown prefix for field %s. Assuming string.\n',strFieldName);
    end
    strClass  = 'string';
end
return;
