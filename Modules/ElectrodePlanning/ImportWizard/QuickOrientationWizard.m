function varargout = QuickOrientationWizard(varargin)
% QUICKORIENTATIONWIZARD MATLAB code for QuickOrientationWizard.fig
%      QUICKORIENTATIONWIZARD, by itself, creates a new QUICKORIENTATIONWIZARD or raises the existing
%      singleton*.
%
%      H = QUICKORIENTATIONWIZARD returns the handle to a new QUICKORIENTATIONWIZARD or the handle to
%      the existing singleton*.
%
%      QUICKORIENTATIONWIZARD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUICKORIENTATIONWIZARD.M with the given input arguments.
%
%      QUICKORIENTATIONWIZARD('Property','Value',...) creates a new QUICKORIENTATIONWIZARD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QuickOrientationWizard_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QuickOrientationWizard_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QuickOrientationWizard

% Last Modified by GUIDE v2.5 30-Nov-2011 08:48:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QuickOrientationWizard_OpeningFcn, ...
                   'gui_OutputFcn',  @QuickOrientationWizard_OutputFcn, ...
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


% --- Executes just before QuickOrientationWizard is made visible.
function QuickOrientationWizard_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QuickOrientationWizard (see VARARGIN)

% Choose default command line output for QuickOrientationWizard
handles.output = hObject;
set(handles.hSaveDefault,'value',1);

strDefaultFile = ['.',filesep,'Config',filesep,'DefaultImportOption.mat'];
if exist(strDefaultFile,'file')
    try
        load(strDefaultFile);
        set(handles.uipanel4,'SelectedObject', getfield(handles,strSelectedOption));
    end
end

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes QuickOrientationWizard wait for user response (see UIRESUME)
uiwait(handles.figure1);
if ~ishandle(handles.figure1)
    return;
end

% --- Outputs from this function are returned to the command line.
function varargout = QuickOrientationWizard_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
if ~isempty(handles) && isfield(handles,'figure1') && ishandle(handles.figure1)
    strSelectedOption = get(get(handles.uipanel4,'SelectedObject'),'Tag');
    if get(handles.hSaveDefault,'value') == 1
        save(['.',filesep,'Config',filesep,'DefaultImportOption.mat'],'strSelectedOption');
    end

    
    strctOrientation.m_a2fAtlasReg  = [...
        -1 0 0 0;
        0 -1 0 0;
        0 0 1 0;
        0 0 0 1];
        
    switch strSelectedOption
        case 'hSiemensHFS_Sphinx'
             strctOrientation.m_a2fSaggital= [0  0  1;
                                             0  -1  0;
                                             -1  0  0];
            
            strctOrientation.m_a2fCoronal= [-1 0 0;
                                            0 -1 0;
                                            0 0 1];
            strctOrientation.m_a2fHoriz  = [-1 0 0;
                                            0 0 1;  
                                            0 1 0];
        case 'hSiemensHFS_NoSphinx'
             strctOrientation.m_a2fSaggital= [0  0  1;
                                             -1  0  0;
                                            0  -1 0];
            
            strctOrientation.m_a2fHoriz= [1 0 0;
                                          0 1 0;
                                          0 0 1];
            strctOrientation.m_a2fCoronal  = [1 0 0;
                                            0 0 1;  
                                            0 -1 0];
            
        case 'hSimendsHFP_NoSphinx'
             strctOrientation.m_a2fSaggital= [0  0  1;
                                             0  1  0;
                                            1  0 0];
            
            strctOrientation.m_a2fCoronal = [1 0 0;
                                          0 1 0;
                                          0 0 1];
            strctOrientation.m_a2fHoriz  = [1 0 0;
                                            0 0 1;  
                                            0 -1 0];
        case 'hBrokerHFS'
            strctOrientation.m_a2fCoronal = [1 0 0;
                                           0 -1 0;
                                           0 0 1];
            strctOrientation.m_a2fSaggital = [0  0 1;
                                              0  -1 0;
                                              -1 0 0];
            strctOrientation.m_a2fHoriz   = [-1 0 0;
                                             0 0 1;
                                             0 1 0];
            
          case 'hFreeSurfer_ManipulatedHeader'
                                       
strctOrientation.m_a2fCoronal   = [
     -1    0     0     ;
     0    1     0    ;
     0     0    -1     ];
     

strctOrientation.m_a2fHoriz= [
    -1     0     0    
     0     0     1 
     0    -1     0  ];

 strctOrientation.m_a2fSaggital= [    
     0     0    -1     ;
     0     1     0     ;
     1    0     0  ]; 
                                          
         strctOrientation.m_a2fAtlasReg  = [...
        2 0  0 0;
        0 0  2 0;
        0 2  0 0;
        0 0 0 1];                                  
                                         
        case 'hUserDefined'
             strctOrientation = fnUserDefinedImport();
    end
    
    varargout{1} = strctOrientation;
    delete(handles.figure1);
else
    varargout{1} = [];
end


% --- Executes on button press in hSiemensHFS_Sphinx.
function hSiemensHFS_Sphinx_Callback(hObject, eventdata, handles)
% hObject    handle to hSiemensHFS_Sphinx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hSiemensHFS_Sphinx


% --- Executes on button press in hSiemensHFS_NoSphinx.
function hSiemensHFS_NoSphinx_Callback(hObject, eventdata, handles)
% hObject    handle to hSiemensHFS_NoSphinx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hSiemensHFS_NoSphinx


% --- Executes on button press in hSaveDefault.
function hSaveDefault_Callback(hObject, eventdata, handles)
% hObject    handle to hSaveDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hSaveDefault


% --- Executes on button press in hSimendsHFP_NoSphinx.
function hSimendsHFP_NoSphinx_Callback(hObject, eventdata, handles)
% hObject    handle to hSimendsHFP_NoSphinx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hSimendsHFP_NoSphinx


% --- Executes on button press in hBrokerHFS.
function hBrokerHFS_Callback(hObject, eventdata, handles)
% hObject    handle to hBrokerHFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hBrokerHFS


% --- Executes on button press in hHelpButton.
function hHelpButton_Callback(hObject, eventdata, handles)
acHelp = {'Why do I need to define how data orientation? Isn''t this information stored in the DICOM?';
          'Yes. Patient orientation is stored in the DICOM. However, NHPs are usually scanned in';
          'non standard orietnation which is not specified by siemens (i.e., sphinx position).';
          'Some users are not aware of this issue and do not fix the orientation in the files.';
          'To keep things simple and to keep maximum compatibility with free surfer tools such as tkregister,';
          'Planner is using two approaches. First, it maps voxel values to metric space using';
          'tkregister fixed vox2ras matrix (a.k.a. tkvox2ras).';
          'Second, it uses the stored DICOM orientation information to define the three cross sections';
          'the user can play with.';
          'Since orientation information may be incorrect, several preset import options are available.';
          'If none of the preset options work properly, try to define your own mapping of default cross section';
          'views using the user defined function (fnUserDefinedImport.m).'};
msgbox(acHelp,'Help');
return;

% --- Executes on button press in hOK.
function hOK_Callback(hObject, eventdata, handles)
setappdata(handles.figure1,'bClickedOK',true);
uiresume(handles.figure1);

% --- Executes on button press in hUserDefined.
function hUserDefined_Callback(hObject, eventdata, handles)
% hObject    handle to hUserDefined (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hUserDefined
