function varargout = SolidWorksExportWizard(varargin)
% SOLIDWORKSEXPORTWIZARD MATLAB code for SolidWorksExportWizard.fig
%      SOLIDWORKSEXPORTWIZARD, by itself, creates a new SOLIDWORKSEXPORTWIZARD or raises the existing
%      singleton*.
%
%      H = SOLIDWORKSEXPORTWIZARD returns the handle to a new SOLIDWORKSEXPORTWIZARD or the handle to
%      the existing singleton*.
%
%      SOLIDWORKSEXPORTWIZARD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOLIDWORKSEXPORTWIZARD.M with the given input arguments.
%
%      SOLIDWORKSEXPORTWIZARD('Property','Value',...) creates a new SOLIDWORKSEXPORTWIZARD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SolidWorksExportWizard_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SolidWorksExportWizard_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SolidWorksExportWizard

% Last Modified by GUIDE v2.5 01-Jul-2013 15:35:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SolidWorksExportWizard_OpeningFcn, ...
                   'gui_OutputFcn',  @SolidWorksExportWizard_OutputFcn, ...
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


% --- Executes just before SolidWorksExportWizard is made visible.
function SolidWorksExportWizard_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SolidWorksExportWizard (see VARARGIN)

% Choose default command line output for SolidWorksExportWizard
handles.output = hObject;
% Generate default output

strctOutput.m_strctGridModel = varargin{1};
strctOutput.m_afRad = fnGenerateDefaultHoleRadius(strctOutput.m_strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg,'Plastic');
strctOutput.m_strTemplate = fullfile(pwd,'Solidworks','Grid_Template.SLDPRT');
strctOutput.m_strOutputFile = fullfile(pwd,'Solidworks','Grid_Modified.SLDPRT');
strctOutput.m_strText = 'Planner Template v2';
strctOutput.m_bCloseSolidworksAfter = false;

setappdata(handles.figure1,'strctOutput',strctOutput);

fnInvalidateList(handles);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SolidWorksExportWizard wait for user response (see UIRESUME)
uiwait(handles.figure1);
try
    close(handles.figure1);
catch
end
return

function fnInvalidateList(handles)
strctOutput = getappdata(handles.figure1,'strctOutput');
[afUniqueTilt, aiIndex, aiIndex2] = unique(strctOutput.m_strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg);

iNumGroups = length(afUniqueTilt);
acDesc = cell(1,iNumGroups);
for k=1:iNumGroups
    acDesc{k} = sprintf('Tilt: %2.2f, %2.3f mm',afUniqueTilt(k),  strctOutput.m_afRad(aiIndex(k)));
end
set(handles.listbox1,'string',acDesc);
set(handles.hModelText, 'String',strctOutput.m_strText);
set(handles.hTemplateFile, 'String',strctOutput.m_strTemplate);
set(handles.hOutputFile, 'String',strctOutput.m_strOutputFile);

iSelected = get(handles.listbox1,'value');
set(handles.hModifySize,'string', sprintf('%.4f',strctOutput.m_afRad(aiIndex(iSelected))));
% set(handles.


function afRad = fnGenerateDefaultHoleRadius(afTilt, strType)
N=length(afTilt);

TiltDeg      = [0,         5,      10,    15,  20];
Plastic      = [0.73  , 0.77,    0.78,  0.79, 0.80 ];
Metal        = [0.69,   0.75,    0.76,  0.77, 0.78];

if strcmpi(strType,'Plastic')
    afRad = interp1(TiltDeg, Plastic, afTilt,'linear','extrap');
else
    afRad = interp1(TiltDeg, Metal, afTilt,'linear','extrap');
end
return



% --- Outputs from this function are returned to the command line.
function varargout = SolidWorksExportWizard_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g_output
% Get default command line output from handles structure
if isempty(g_output)
    varargout{1} =[];
    return;
else
    varargout{1} = g_output;
end
clear global g_output

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
strctOutput = getappdata(handles.figure1,'strctOutput');
[afUniqueTilt, aiIndex, aiIndex2] = unique(strctOutput.m_strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg);
iSelected = get(handles.listbox1,'value');
set(handles.hModifySize,'string', sprintf('%.4f',strctOutput.m_afRad(aiIndex(iSelected))));
return

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hOK.
function hOK_Callback(hObject, eventdata, handles)
global g_output
g_output = getappdata(handles.figure1,'strctOutput');
uiresume(handles.figure1);

% --- Executes on button press in hCancel.
function hCancel_Callback(hObject, eventdata, handles)
global g_output
g_output = [];
uiresume(handles.figure1);


% --- Executes on button press in hDefaultPlastic.
function hDefaultPlastic_Callback(hObject, eventdata, handles)
strctOutput = getappdata(handles.figure1,'strctOutput');
strctOutput.m_afRad = fnGenerateDefaultHoleRadius(strctOutput.m_strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg,'Plastic');
setappdata(handles.figure1,'strctOutput',strctOutput);
fnInvalidateList(handles);


% --- Executes on button press in hDefaultMetal.
function hDefaultMetal_Callback(hObject, eventdata, handles)
strctOutput = getappdata(handles.figure1,'strctOutput');
strctOutput.m_afRad = fnGenerateDefaultHoleRadius(strctOutput.m_strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg,'Metal');
setappdata(handles.figure1,'strctOutput',strctOutput);
fnInvalidateList(handles);



function hTemplateFile_Callback(hObject, eventdata, handles)
% hObject    handle to hTemplateFile (see GCBO)
strctOutput = getappdata(handles.figure1,'strctOutput');

if exist(get(hObject,'string'),'file')
    strctOutput.m_strTemplate = get(hObject,'string');
    setappdata(handles.figure1,'strctOutput',strctOutput);
else
    set(hObject,'string',strctOutput.m_strTemplate );
end

% --- Executes during object creation, after setting all properties.
function hTemplateFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hTemplateFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hOutputFile_Callback(hObject, eventdata, handles)
strctOutput = getappdata(handles.figure1,'strctOutput');

strctOutput.m_strOutputFile = get(hObject,'string');
setappdata(handles.figure1,'strctOutput',strctOutput);


% --- Executes during object creation, after setting all properties.
function hOutputFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hOutputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hBrowseTemplate.
function hBrowseTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to hBrowseTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('.\Solidworks\*.*');
strTemplateFile = fullfile(PathName, FileName);

strctOutput = getappdata(handles.figure1,'strctOutput');
if exist(strTemplateFile,'file')
    strctOutput.m_strTemplate = strTemplateFile;
    setappdata(handles.figure1,'strctOutput',strctOutput);
else
    set(hObject,'string',strctOutput.m_strTemplate );
end
set(handles.hTemplateFile, 'String',strctOutput.m_strTemplate);



% --- Executes on button press in hBrowseOutput.
function hBrowseOutput_Callback(hObject, eventdata, handles)
% hObject    handle to hBrowseOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hCloseAfter.
function hCloseAfter_Callback(hObject, eventdata, handles)
% hObject    handle to hCloseAfter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hCloseAfter



function hModelText_Callback(hObject, eventdata, handles)
% hObject    handle to hModelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hModelText as text
%        str2double(get(hObject,'String')) returns contents of hModelText as a double


% --- Executes during object creation, after setting all properties.
function hModelText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hModelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hModifySize.
function hModifySize_Callback(hObject, eventdata, handles)
strctOutput = getappdata(handles.figure1,'strctOutput');
[afUniqueTilt, aiIndex, aiIndex2] = unique(strctOutput.m_strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg);
iSelected = get(handles.listbox1,'value');
strctOutput.m_afRad(strctOutput.m_strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg == afUniqueTilt(iSelected)) = str2num(get(hObject,'string'));
setappdata(handles.figure1,'strctOutput',strctOutput);
fnInvalidateList(handles);

% --- Executes during object creation, after setting all properties.
function hModifySize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hModifySize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
