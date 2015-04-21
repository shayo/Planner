function varargout = StereotaxMarkersGUI(varargin)
% STEREOTAXMARKERSGUI MATLAB code for StereotaxMarkersGUI.fig
%      STEREOTAXMARKERSGUI, by itself, creates a new STEREOTAXMARKERSGUI or raises the existing
%      singleton*.
%
%      H = STEREOTAXMARKERSGUI returns the handle to a new STEREOTAXMARKERSGUI or the handle to
%      the existing singleton*.
%
%      STEREOTAXMARKERSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEREOTAXMARKERSGUI.M with the given input arguments.
%
%      STEREOTAXMARKERSGUI('Property','Value',...) creates a new STEREOTAXMARKERSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StereotaxMarkersGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StereotaxMarkersGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StereotaxMarkersGUI

% Last Modified by GUIDE v2.5 21-Dec-2012 20:54:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StereotaxMarkersGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @StereotaxMarkersGUI_OutputFcn, ...
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


% --- Executes just before StereotaxMarkersGUI is made visible.
function StereotaxMarkersGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StereotaxMarkersGUI (see VARARGIN)

dat =  {6.125, 456.3457, true,  'Fixed';...
        6.75,  510.2342, false, 'Adjustable';...   
        7,     658.2,    false, 'Fixed';};
columnname =   {'Feature No.','Arm', 'AP (mm)', 'DV (mm)','ML (mm)','DV (deg)','AP (deg)','Rot 90','Aux Trans','Tool Rot'};
columnformat = {'numeric',{'Kopf 1430 Left','Kopf 1430 Right'}, ...
                'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'};
columneditable =  [false true true true true true true true true true ]; 
set(handles.hTable,'Units','normalized','Position',...
            [0.1 0.1 0.9 0.9], 'Data', dat,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', columneditable,...
            'RowName',[]);
        
% Choose default command line output for StereotaxMarkersGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StereotaxMarkersGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StereotaxMarkersGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
