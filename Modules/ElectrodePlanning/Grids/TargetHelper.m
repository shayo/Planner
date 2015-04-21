function varargout = TargetHelper(varargin)
% TARGETHELPER M-file for TargetHelper.fig
%      TARGETHELPER, by itself, creates a new TARGETHELPER or raises the existing
%      singleton*.
%
%      H = TARGETHELPER returns the handle to a new TARGETHELPER or the handle to
%      the existing singleton*.
%
%      TARGETHELPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TARGETHELPER.M with the given input arguments.
%
%      TARGETHELPER('Property','Value',...) creates a new TARGETHELPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TargetHelper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TargetHelper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TargetHelper

% Last Modified by GUIDE v2.5 23-Mar-2011 13:14:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TargetHelper_OpeningFcn, ...
                   'gui_OutputFcn',  @TargetHelper_OutputFcn, ...
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


% --- Executes just before TargetHelper is made visible.
function TargetHelper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TargetHelper (see VARARGIN)

% Choose default command line output for TargetHelper
handles.output = hObject;
apt3fTargetsPosMM = varargin{1};
strctChamber = varargin{2};
strctGrid = varargin{3};
a2fCRS_To_XYZ = varargin{4};

if ~isfield(strctGrid.m_strctModel.m_strctGridParams,'m_acParam')
    return
end
setappdata(handles.figure1,'apt3fTargetsPosMM',apt3fTargetsPosMM);
setappdata(handles.figure1,'strctChamber',strctChamber);
setappdata(handles.figure1,'strctGrid',strctGrid);
setappdata(handles.figure1,'a2fCRS_To_XYZ',a2fCRS_To_XYZ);


set(handles.figure1,'visible','on')

iNumParams = length(strctGrid.m_strctModel.m_strctGridParams.m_acParam);
a2cData = cell(iNumParams, 4);
acColumnName = {'Parameter','Fixed Values','Optimize?','Optimal Value'};
for iParamIter=1:iNumParams
    a2cData{iParamIter,1} = strctGrid.m_strctModel.m_strctGridParams.m_acParam{iParamIter}.m_strDescription;
    switch strctGrid.m_strctModel.m_strctGridParams.m_acParam{iParamIter}.m_strType
        case 'Continuous'
            a2cData{iParamIter,2} = num2str(strctGrid.m_strctModel.m_strctGridParams.m_acParam{iParamIter}.m_Value);
            case 'Discrete'
                a2cData{iParamIter,2} = num2str(strctGrid.m_strctModel.m_strctGridParams.m_acParam{iParamIter}.m_Value);
            case 'Logical'
                if strctGrid.m_strctModel.m_strctGridParams.m_acParam{iParamIter}.m_Value
                    a2cData{iParamIter,2} = 'true';
                else
                    a2cData{iParamIter,2} = 'false';
                end
            case 'String'
                a2cData{iParamIter,2} = strctGrid.m_strctModel.m_strctGridParams.m_acParam{iParamIter}.m_Value;
        end
     a2cData{iParamIter,3} = false;
     
end
set(handles.hTable,'Data',a2cData,'ColumnEditable',[false true true false],'ColumnName',acColumnName,'ColumnFormat',{'char','char','logical','char'},'ColumnWidth',{250 100 80 100},...
    'CellEditCallback',@fnCellEditCallback,'UserData',handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TargetHelper wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TargetHelper_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in hSolve.
function hSolve_Callback(hObject, eventdata, handles)
global g_bStop

apt3fTargetsPosMM = getappdata(handles.figure1,'apt3fTargetsPosMM');
a2fCRS_To_XYZ = getappdata(handles.figure1,'a2fCRS_To_XYZ');
strctChamber = getappdata(handles.figure1,'strctChamber');
strctGrid = getappdata(handles.figure1,'strctGrid');
a2cData = get(handles.hTable,'Data');
abOptimize = cat(1,a2cData{:,3});
aiOptimize = find(abOptimize);
iNumParamToOpt = sum(abOptimize);
if iNumParamToOpt == 0
    h=msgbox('Please select which parameter to optimize on');
    waitfor(h);
    return;
end;
for k=1:iNumParamToOpt
    % Make sure it is continous
    if ~strcmpi(strctGrid.m_strctModel.m_strctGridParams.m_acParam{aiOptimize(k)}.m_strType,'Continuous')
     h=msgbox('Can not optimize on a parameter that is not continuous');
    waitfor(h);
    return;
    end;
end

afInitialValues = zeros(1,iNumParamToOpt);
for k=1:iNumParamToOpt
    iParameterIndex = aiOptimize(k);
    afInitialValues(k) = strctGrid.m_strctModel.m_strctGridParams.m_acParam{iParameterIndex}.m_Value;
end


a2fM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;
a2fGridOffsetTransform = eye(4);
a2fGridOffsetTransform(3,4) = -strctGrid.m_fChamberDepthOffset;
a2fM_WithMeshOffset =a2fM*a2fGridOffsetTransform;

options = optimset('MaxIter',1000,'Display','Iter','Tolx',1e-8);
options.Axes = handles.axes1;
afOptParam=fnMyfminsearch(@(x)fnGridErrorFuncWrapper(x, aiOptimize, strctGrid,apt3fTargetsPosMM, a2fM_WithMeshOffset), afInitialValues,options);


% For each combination, generate a grid model and test all holes !
strctGridParams = strctGrid.m_strctModel.m_strctGridParams;
% Apply the parameters...
for iParamIter=1:iNumParamToOpt
    strctGridParams.m_acParam{  aiOptimize(iParamIter)}.m_Value = afOptParam(iParamIter);%a2fCombinations(iBestModel,iParamIter);
end;

strctModel = feval(strctGrid.m_strctGeneral.m_strBuildModel,strctGridParams);
[fError, afMinDistToTarget, aiBestHoleInThisModel]=fnGridErrorFunction(strctModel,apt3fTargetsPosMM, a2fM_WithMeshOffset);

strctModel.m_strctGridParams.m_abSelectedHoles(aiBestHoleInThisModel) = true;
feval(strctGrid.m_strctGeneral.m_strDraw2D,strctModel, handles.hGridAxes, []);
setappdata(handles.figure1,'strctOptModel',strctModel);

iNumParams = length(strctGridParams.m_acParam);
for iParamIter=1:iNumParams
    switch strctGridParams.m_acParam{iParamIter}.m_strType
        case 'Continuous'
            a2cData{iParamIter,4} = num2str(strctGridParams.m_acParam{iParamIter}.m_Value);
        case 'Discrete'
            a2cData{iParamIter,4} = num2str(strctGridParams.m_acParam{iParamIter}.m_Value);
        case 'Logical'
            if strctGridParams.m_acParam{iParamIter}.m_Value
                a2cData{iParamIter,4} = 'true';
            else
                a2cData{iParamIter,4} = 'false';
            end
        case 'String'
            a2cData{iParamIter,4} = strctGridParams.m_acParam{iParamIter}.m_Value;
    end
end
set(handles.hTable,'Data',a2cData);
return;


% --- Executes on button press in hAddSolution.
function hAddSolution_Callback(hObject, eventdata, handles)
strctOptModel = getappdata(handles.figure1,'strctOptModel');

if ~isempty(strctOptModel)
    strctGrid =getappdata(handles.figure1,'strctGrid');
    strctGrid.m_strctModel = strctOptModel;
   fnElectrodePlanningNewCallback('AddGridFromModel', strctGrid);
end

% --- Executes on button press in hStop.
function hStop_Callback(hObject, eventdata, handles)
global g_bStop
g_bStop = true;


% --- Executes on button press in bUseStopCritertion.
function bUseStopCritertion_Callback(hObject, eventdata, handles)
% hObject    handle to bUseStopCritertion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bUseStopCritertion




function fnCellEditCallback(source,eventdata)
handles = get(source,'UserData');
iNewParameterIndex = eventdata.Indices(1,1);
if eventdata.Indices(1,2) ~= 2
    return;
end;
setappdata(handles.figure1,'iCurrentParameter',iNewParameterIndex);
% Update scroll bar...
%set(handles.    ,'iCurrentParameter',eventdata.Indices(1));
strctGrid = getappdata(handles.figure1,'strctGrid');

switch strctGrid.m_strctModel.m_strctGridParams.m_acParam{iNewParameterIndex}.m_strType
    case 'Discrete'
        NewValue = str2num(eventdata.NewData);
    case 'Logical'
        NewValue = str2num(eventdata.NewData) > 0;
    case 'Continuous'
        NewValue = str2num(eventdata.NewData);
    case 'String'
        NewValue = eventdata.NewData;
end

strctGrid.m_strctModel.m_strctGridParams.m_acParam{iNewParameterIndex}.m_Value = NewValue;

setappdata(handles.figure1,'strctGrid',strctGrid);
return;
