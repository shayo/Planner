function fnMyStructToXML(strctConfig, strFilename)
hFileHandle = fopen(strFilename,'w+');
Depth = 0;
fprintf(hFileHandle,'<Config>\n');
fnRecursivePrint(strctConfig, Depth, hFileHandle)
fprintf(hFileHandle,'</Config>\n');
fclose(hFileHandle);
return;


function fnRecursivePrint(strctConfig, Depth, hFileHandle)
acFieldNames = fieldnames(strctConfig);
iNumFields = length(acFieldNames);

for iIter=1:iNumFields
    Tmp = getfield(strctConfig,acFieldNames{iIter});
    switch class(Tmp)
        case 'struct'
            
            bHasMoreRecursion = fnOnlyAttributes(Tmp);
            
            if ~bHasMoreRecursion
                fprintf(hFileHandle,'\n');
                fnPrintTab(hFileHandle,Depth)
                fprintf(hFileHandle,'<%s\n',acFieldNames{iIter});
                fnRecursivePrint(Tmp, Depth+1, hFileHandle);
                fprintf(hFileHandle,'\n');
                fnPrintTab(hFileHandle,Depth)
                fprintf(hFileHandle,'> </%s>\n\n',acFieldNames{iIter});
            else
                fnPrintTab(hFileHandle,Depth)
                fprintf(hFileHandle,'<%s>\n',acFieldNames{iIter});
                fnRecursivePrint(Tmp, Depth+1, hFileHandle);
                fprintf(hFileHandle,'\n');
                fnPrintTab(hFileHandle,Depth)
                fprintf(hFileHandle,'</%s>\n\n',acFieldNames{iIter});
                
            end
            
        case 'cell'
                for k=1:length(Tmp);
                    bOnlyAttr =  ~fnOnlyAttributes(Tmp{k});
                
                    fnPrintTab(hFileHandle,Depth)
                    if bOnlyAttr
                        fprintf(hFileHandle,'<%s\n',acFieldNames{iIter});
                    else
                        fprintf(hFileHandle,'<%s>\n',acFieldNames{iIter});
                    end
                    fnRecursivePrint(Tmp{k}, Depth+1, hFileHandle);
                    fnPrintTab(hFileHandle,Depth)
                    if bOnlyAttr
                        fprintf(hFileHandle,'> </%s>\n\n',acFieldNames{iIter});
                    else
                        fprintf(hFileHandle,'</%s>\n\n',acFieldNames{iIter});
                    end
                end
           
        case 'double'
            fnPrintTab(hFileHandle,Depth)
            fprintf(hFileHandle,'%s = "',acFieldNames{iIter});
            for j=1:length(Tmp)
                if j > 1
                    fprintf(hFileHandle,' ');
                end
                if Tmp(j)-round(Tmp(j)) == 0
                    fprintf(hFileHandle,'%d',Tmp(j));
                else
                    fprintf(hFileHandle,'%.2f',Tmp(j));
                end
                
            end
            fprintf(hFileHandle,'"\n');
        case 'logical'
            fnPrintTab(hFileHandle,Depth)
            fprintf(hFileHandle,'%s = "%d"\n', acFieldNames{iIter},double(Tmp));
        case 'char'
            fnPrintTab(hFileHandle,Depth)
            fprintf(hFileHandle,'%s = "%s"\n', acFieldNames{iIter},Tmp);
        otherwise
            dbg = 1;
            assert(false);
    end
end

function fnPrintTab(hFileHandle,Depth)
iTabLength = 10;
for k=1:Depth*iTabLength
    fprintf(hFileHandle,' ');
end;
function bHasMoreRecursion = fnOnlyAttributes(Tmp)
bHasMoreRecursion = false;
if iscell(Tmp)
    for k=1:length(Tmp)
        bRes = fnOnlyAttributes(Tmp{k});
        bHasMoreRecursion = bHasMoreRecursion | bRes;
    end
else
    acFieldNames = fieldnames(Tmp);
    for k=1:length(acFieldNames)
        switch class(getfield(Tmp,acFieldNames{k}))
            case 'cell'
                bHasMoreRecursion = true;
            case 'struct'
                bHasMoreRecursion = true;
        end
    end
end
return

