
function fnSafeDelete(ahHandles)
    if isempty(ahHandles)
        return;
    end
    delete(ahHandles(ishandle(ahHandles)))
return;
