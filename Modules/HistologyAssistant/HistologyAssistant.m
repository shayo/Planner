function varargout = HistologyAssistant(varargin)
% HISTOLOGYASSISTANT MATLAB code for HistologyAssistant.fig
%      HISTOLOGYASSISTANT, by itself, creates a new HISTOLOGYASSISTANT or raises the existing
%      singleton*.
%
%      H = HISTOLOGYASSISTANT returns the handle to a new HISTOLOGYASSISTANT or the handle to
%      the existing singleton*.
%
%      HISTOLOGYASSISTANT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HISTOLOGYASSISTANT.M with the given input arguments.
%
%      HISTOLOGYASSISTANT('Property','Value',...) creates a new HISTOLOGYASSISTANT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HistologyAssistant_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HistologyAssistant_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HistologyAssistant

% Last Modified by GUIDE v2.5 20-Jan-2013 15:46:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HistologyAssistant_OpeningFcn, ...
                   'gui_OutputFcn',  @HistologyAssistant_OutputFcn, ...
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


% --- Executes just before HistologyAssistant is made visible.
function HistologyAssistant_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HistologyAssistant (see VARARGIN)

% Choose default command line output for HistologyAssistant
handles.output = hObject;
dbstop if error
strRoot = 'D:\Photos\Work Related\Bert Histology\';
setappdata(handles.figure1,'strRoot',strRoot);
astrctFiles = dir([strRoot,'*.jpg']);

set(handles.listbox1,'String',{astrctFiles.name});

I=imread([strRoot,astrctFiles(1).name]);
aiImageSize = size(I);
Iz = zeros(aiImageSize,'uint8');
hImage = image(Iz,'parent',handles.axes1);
setappdata(handles.figure1,'hImage',hImage);


fnSetTemplate(handles,astrctFiles(1).name);
fnLoadAndOverlay(handles,astrctFiles(1).name);

set(handles.axes1,'units','pixels')
% Update handles structure
%set(handles.axes1,'WindowButtonMotionFcn',@fnMouseMove);
%set(handles.axes1,'WindowButtonDownFcn',@fnMouseDown);
%set(handles.axes1,'WindowButtonUpFcn',@fnMouseUp);
%set(handles.axes1,'WindowScrollWheelFcn',@fnMouseWheel);
set(handles.figure1,'KeyPressFcn',@fnKeyDown);
set(handles.figure1,'KeyReleaseFcn',@fnKeyUp);
setappdata(handles.figure1,'a2fT',eye(3));
guidata(hObject, handles);

% UIWAIT makes HistologyAssistant wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function fnKeyDown(hFig,b)
a2fT = getappdata(hFig,'a2fT');
switch b.Key
    case 'uparrow'
        
    case 'downarrow'
        
    case 'leftarrow'
        
    case 'rightarrow'
        
    case 'pageup'
        
    case 'home'
        
end
setappdata(hFig,'a2fT',a2fT);

return;

function fnKeyUp(a,b)
return;

% --- Outputs from this function are returned to the command line.
function varargout = HistologyAssistant_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function fnSetTemplate(handles,strFile)
strRoot = getappdata(handles.figure1,'strRoot');
I=imread([strRoot,strFile]);
setappdata(handles.figure1,'a2iTemplate',rgb2gray(I));
return



function fnLoadAndOverlay(handles,strFile)
hImage = getappdata(handles.figure1,'hImage');
strRoot = getappdata(handles.figure1,'strRoot');
a2iTemplate=getappdata(handles.figure1,'a2iTemplate');
a2fT = getappdata(handles.figure1,'a2fT');

 I=imread([strRoot,strFile]);
% Ig = rgb2gray(I);
% J(:,:,1) = a2iTemplate;
% J(:,:,2) = Ig;
% J(:,:,3) = Ig;

% Tmp = get(handles.axes1,'position');
% aiImageSize = Tmp(3:4);
% J=imresize(I,aiImageSize);

set(hImage,'cdata',I);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
files = get(hObject,'String');
strFile = files{get(hObject,'value')};
fnLoadAndOverlay(handles,strFile);


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
files = get(handles.listbox1,'String');
strFile = files{get(handles.listbox1,'value')};
fnSetTemplate(handles,strFile);
fnLoadAndOverlay(handles,strFile);
