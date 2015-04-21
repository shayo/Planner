function varargout = ImageSeriesInfoGUI(varargin)
% IMAGESERIESINFOGUI MATLAB code for ImageSeriesInfoGUI.fig
%      IMAGESERIESINFOGUI, by itself, creates a new IMAGESERIESINFOGUI or raises the existing
%      singleton*.
%
%      H = IMAGESERIESINFOGUI returns the handle to a new IMAGESERIESINFOGUI or the handle to
%      the existing singleton*.
%
%      IMAGESERIESINFOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGESERIESINFOGUI.M with the given input arguments.
%
%      IMAGESERIESINFOGUI('Property','Value',...) creates a new IMAGESERIESINFOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageSeriesInfoGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageSeriesInfoGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageSeriesInfoGUI

% Last Modified by GUIDE v2.5 07-Feb-2013 15:17:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageSeriesInfoGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageSeriesInfoGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ImageSeriesInfoGUI is made visible.
function ImageSeriesInfoGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageSeriesInfoGUI (see VARARGIN)

% Choose default command line output for ImageSeriesInfoGUI
handles.output = hObject;
if length(varargin) == 0
    strctImageSeries.m_strName = 'YFP';
strctImageSeries.m_fInterImageDist = 0.5;
strctImageSeries.m_fImageThickness = 0.5;
strctImageSeries.m_afColorMapping = [1 0 0]; % if single channel
strctImageSeries.m_acImages = cell(0);
strctImageSeries.m_iResizePix = 800;
strctImageSeries.m_a2fImagePlaneTo3D = eye(4); 
strctImageSeries.m_strOrientation = 'coronal';
strctImageSeries.m_fOpacity = 0.8;
strctImageSeries.m_acImages = {};
else
strctImageSeries = varargin{1};
end
setappdata(handles.figure1,'strctImageSeries',strctImageSeries);
% Update handles structure
setappdata(handles.figure1,'bCancel',false)
%set(handles.figure1,'visible','on')
set(handles.hSeriesName,'String',strctImageSeries.m_strName);
set(handles.hInterSliceDistance,'String',num2str(strctImageSeries.m_fInterImageDist));
set(handles.hSliceThickness,'String',num2str(strctImageSeries.m_fImageThickness));
set(handles.hResize,'String',num2str(strctImageSeries.m_iResizePix));
set(handles.hSeriesColor,'ForegroundColor',strctImageSeries.m_afColorMapping);
if strcmpi(strctImageSeries.m_strOrientation ,'coronal')
    set(handles.hCoronal,'value',1);
elseif strcmpi(strctImageSeries.m_strOrientation ,'horizontal')
    set(handles.hHoriz,'value',1);
else 
    set(handles.hSagittal,'value',1);
end


guidata(hObject, handles);

% UIWAIT makes ImageSeriesInfoGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);
if getappdata(handles.figure1,'bCancel')
    handles.output = [];
else
    handles.output = getappdata(handles.figure1,'strctImageSeries');
end
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = ImageSeriesInfoGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);


% --- Executes on button press in hOK.
function hOK_Callback(hObject, eventdata, handles)
if isempty(get(handles.hSeriesName,'String'))
    h=msgbox('Must enter a name!');
    waitfor(h);
    return;
end;

uiresume(handles.figure1);

% --- Executes on button press in hCancel.
function hCancel_Callback(hObject, eventdata, handles)
setappdata(handles.figure1,'bCancel',true);
uiresume(handles.figure1);



function hSeriesName_Callback(hObject, eventdata, handles)
% hObject    handle to hSeriesName (see GCBO)
strctImageSeries=getappdata(handles.figure1,'strctImageSeries');
strctImageSeries.m_strName = get(hObject,'string');
setappdata(handles.figure1,'strctImageSeries',strctImageSeries);
return;

% --- Executes during object creation, after setting all properties.
function hSeriesName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hSeriesName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hInterSliceDistance_Callback(hObject, eventdata, handles)
strctImageSeries=getappdata(handles.figure1,'strctImageSeries');
strctImageSeries.m_fInterImageDist = str2num(get(hObject,'string'));
setappdata(handles.figure1,'strctImageSeries',strctImageSeries);
return;


% --- Executes during object creation, after setting all properties.
function hInterSliceDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hInterSliceDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hSliceThickness_Callback(hObject, eventdata, handles)
strctImageSeries=getappdata(handles.figure1,'strctImageSeries');
strctImageSeries.m_fImageThickness = str2num(get(hObject,'string'));
setappdata(handles.figure1,'strctImageSeries',strctImageSeries);
return;

% --- Executes during object creation, after setting all properties.
function hSliceThickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hSliceThickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hSeriesColor.
function hResize_Callback(hObject, eventdata, handles)
strctImageSeries=getappdata(handles.figure1,'strctImageSeries');
strctImageSeries.m_iResizePix = str2num(get(hObject,'string'));
setappdata(handles.figure1,'strctImageSeries',strctImageSeries);
return;

function hSeriesColor_Callback(hObject, eventdata, handles)
strctImageSeries=getappdata(handles.figure1,'strctImageSeries');
X=uisetcolor();
if length(X) == 1
    return;
end
strctImageSeries.m_afColorMapping = X;
set(handles.hSeriesColor,'ForegroundColor',strctImageSeries.m_afColorMapping);
setappdata(handles.figure1,'strctImageSeries',strctImageSeries);
return;


% --- Executes during object creation, after setting all properties.
function hResize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hResize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
strctImageSeries=getappdata(handles.figure1,'strctImageSeries');
X=get(hObject,'value');
if X == 1
    strctImageSeries.m_strOrientation = 'horizontal';
elseif X == 2
    
    strctImageSeries.m_strOrientation  = 'sagittal';
    
else trctImageSeries.m_strOrientation  = 'coronal';
end
setappdata(handles.figure1,'strctImageSeries',strctImageSeries);

