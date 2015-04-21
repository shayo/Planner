function [bInside] = fnInsideImage(handles, window_handle)
set(handles.figure1,'Units','pixels');
set(window_handle,'Units','pixels');
MousePos = get(handles.figure1,'CurrentPoint');
AxesRect = get(window_handle,'Position');
bInside =  (MousePos(1) > AxesRect(1) && ...
    MousePos(1) < AxesRect(1)+AxesRect(3) && ...
    MousePos(2) > AxesRect(2) &&  ...
    MousePos(2) < AxesRect(2)+AxesRect(4));
return;