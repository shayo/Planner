function bSame = fnSameStruct(strctA, strctB)
bSame = false;

if isempty(strctA) && isempty(strctB)
    bSame = true;
    return;
end;

if (isempty(strctA) &&~isempty(strctB)) ||  (~isempty(strctA) && isempty(strctB))  || ...
        (isstruct(strctA) && ~isstruct(strctB)) || (~isstruct(strctA) && isstruct(strctB))
    return;
end;

acFieldsA = fieldnames(strctA);
acFieldsB = fieldnames(strctB);

if ~isempty(setdiff(acFieldsA,acFieldsB)) || ~isempty(setdiff(acFieldsB,acFieldsA))
    return;
end;

for iFieldIter=1:length(acFieldsA)
    A = getfield(strctA, acFieldsA{iFieldIter});
    B = getfield(strctB, acFieldsA{iFieldIter});
    if isstruct(A)
        if ~fnSameStruct(A,B)
            return;
        end;
    elseif ischar(A)
        if ~strcmp(A,B)
            return;
        end;
    elseif iscell(A)
        error('not supported');
    else
        if sum(abs(A(:)-B(:))) ~= 0
            return;
        end;
    end;
    
                
end;

bSame = true;

return;
