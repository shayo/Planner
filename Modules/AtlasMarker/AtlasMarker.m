function varargout = AtlasMarker(varargin)
% ATLASMARKER MATLAB code for AtlasMarker.fig
%      ATLASMARKER, by itself, creates a new ATLASMARKER or raises the existing
%      singleton*.
%
%      H = ATLASMARKER returns the handle to a new ATLASMARKER or the handle to
%      the existing singleton*.
%
%      ATLASMARKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ATLASMARKER.M with the given input arguments.
%
%      ATLASMARKER('Property','Value',...) creates a new ATLASMARKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AtlasMarker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AtlasMarker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AtlasMarker

% Last Modified by GUIDE v2.5 28-Jan-2013 13:54:52

if nargin >=1 && (strcmpi(varargin{1},'Invalidate')  || strcmpi(varargin{1},'PrepareForModuleSwitch') || ...
        strcmpi(varargin{1},'AppClose') || strcmpi(varargin{1},'MouseMove') || strcmpi(varargin{1},'MouseUp') || strcmpi(varargin{1},'MouseDown')  || strcmpi(varargin{1},'Wheel')  || strcmpi(varargin{1},'KeyUp') || strcmpi(varargin{1},'KeyDown')  )
    return;
end;
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AtlasMarker_OpeningFcn, ...
                   'gui_OutputFcn',  @AtlasMarker_OutputFcn, ...
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


% --- Executes just before AtlasMarker is made visible.
function AtlasMarker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AtlasMarker (see VARARGIN)

%setappdata(handles.figure1,'strOverlayFolder','D:\Code\Doris\MRI\planner\AtlasMarker\Pictures\');
%fnLoadAtlasFile(handles,'Atlas.mat',true);
setappdata(handles.figure1,'strOverlayFolder','D:\Photos\Work Related\Bert Histology\');
set(handles.figure1,'visible','on')
fnLoadAtlasFile(handles,'AtlasBert.mat',true);

% fnUpdateMetaList(handles,1);
% fnUpdateSliceList(handles, 1);
% fnUpdateRegionList(handles);
% fnSetActiveSlice(handles, 1);

% Choose default command line output for AtlasMarker
handles.output = hObject;
set(handles.figure1,'CloseRequestFcn', @fnMyClose);
set(handles.hSearchRegionEdit,'KeyPressFcn',{@fnRegionSearch, handles});
cameratoolbar show
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AtlasMarker wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function fnRegionSearch(a,b,handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
strSearch = get(a,'string');
if strcmp(b.Key,'backspace')
    strSearch=strSearch(1:end-1);
else
    strSearch = [strSearch,b.Character];
end
acMatches = strfind(lower(strctAtlas.m_acRegions), lower(strSearch));
for k=1:length(acMatches)
    if ~isempty(acMatches{k})
        set(handles.hRegionsList,'value',k);
            return;
        end
end

return;



% iNumRegions = length(strctAtlas.m_acRegions) = {'V1','V2','V3','V4','V5/MT','TE','TEO','FEF'};

function fnUpdateSliceList(handles, iSelectedSlice)

strctAtlas = getappdata(handles.figure1,'strctAtlas');
iNumSlices = length(strctAtlas.m_astrctSlices);
acSliceNames = cell(1,iNumSlices);
for iSliceIter=1:iNumSlices
    acSliceNames{iSliceIter} = sprintf('%.2f',strctAtlas.m_astrctSlices(iSliceIter).m_fPositionMM);
end

set(handles.hSlicesList,'String',acSliceNames,'value',iSelectedSlice);

return;


function fnMyClose(hFigure1,b)
fnSave(hFigure1,true);
delete(gcbf);
return;


% --- Outputs from this function are returned to the command line.
function varargout = AtlasMarker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in hRegionsList.
function hRegionsList_Callback(hObject, eventdata, handles)
% hObject    handle to hRegionsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hRegionsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hRegionsList


% --- Executes during object creation, after setting all properties.
function hRegionsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hRegionsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hAddNewRegion.
function hAddNewRegion_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
prompt={'Enter new region:'};
name='New brain region name';
numlines=1;
defaultanswer={''};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return;
end;
strctAtlas.m_acRegions{end+1} = answer{1};
fnUpdateAtlasStruct(handles.figure1,strctAtlas);
fnUpdateRegionList(handles);
return;

% --- Executes on button press in hDeleteRegion.
function hDeleteRegion_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveRegion = get(handles.hRegionsList,'value');
if isempty(strctAtlas.m_acRegions)
    return;
end;
strctAtlas.m_acRegions(iActiveRegion) = [];
fnUpdateAtlasStruct(handles.figure1,strctAtlas);
fnUpdateRegionList(handles);
return;



function hSearchRegionEdit_Callback(hObject, eventdata, handles)
% hObject    handle to hSearchRegionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hSearchRegionEdit as text
%        str2double(get(hObject,'String')) returns contents of hSearchRegionEdit as a double


% --- Executes during object creation, after setting all properties.
function hSearchRegionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hSearchRegionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in hSlicesList.
function hSlicesList_Callback(hObject, eventdata, handles)
iNewSlice = get(hObject,'value');
fnSetActiveSlice(handles, iNewSlice);

% --- Executes during object creation, after setting all properties.
function hSlicesList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hSlicesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hSave.
function hSave_Callback(hObject, eventdata, handles)
 fnSave(handles.figure1,false);
 return;
 
function fnSave(hFigure1, bAsk)
strCurrentAtlasFile = getappdata(hFigure1,'strCurrentAtlasFile');
bChanged= getappdata(hFigure1,'bChanged');
if isempty(bChanged)
    bChanged = false;
end
if bAsk && bChanged
    ans=questdlg('Save?','Warning','Yes','No','No');
    if ~strcmp(ans,'Yes')
        return;
    end
end

if bChanged
    strctAtlas = getappdata(hFigure1,'strctAtlas');
    if isempty(strCurrentAtlasFile)
    [strFile,strPath]=uiputfile();
    else
        [strFile,strPath]=uiputfile(strCurrentAtlasFile);
    end
    if strFile(1) == 0
        return;
    end;
    strCurrentAtlasFile = fullfile(strPath,strFile);
    setappdata(hFigure1,'strCurrentAtlasFile',strCurrentAtlasFile);
    save(strCurrentAtlasFile,'strctAtlas');
    msgbox('Saved!','Saved');
end

return;

% --- Executes on button press in hAddSlice.
function hAddSlice_Callback(hObject, eventdata, handles)
 [strFile,strPath] = uigetfile('D:\Photos\Work Related\Bert Histology\*');
if strFile(1) == 0
    return;
end;
strFullSliceName = fullfile(strPath,strFile);
I = imread(strFullSliceName);

 if 0

figure(1);
clf;
[a2bMask, xi, yi]  = roipoly(I);
delete(1);
% Estimate the homography for unwrapping....
iTargetSizeWidth = 1000;
iTargetSizeHeight = 1000*2;

A = [xi(1) yi(1) 1   0       0      0;
         0       0        0 xi(1) yi(1) 1;
         
        xi(2) yi(2) 1   0       0      0;
         0       0        0 xi(2) yi(2) 1;
         
        xi(3) yi(3) 1   0       0      0;
         0       0        0 xi(3) yi(3) 1;
         
        xi(4) yi(4) 1   0       0      0;
         0       0        0 xi(4) yi(4) 1];
         
% A * h = b          
b = [1;
        1;
        iTargetSizeWidth;
        1;
        iTargetSizeWidth;
        iTargetSizeHeight;
         1;
        iTargetSizeHeight;
        ];
h=A\b;
H = [h(1) h(2) h(3);
         h(4) h(5) h(6);
         0 0 1];
     
[a2iX, a2iY] = meshgrid(1:iTargetSizeWidth,     1:iTargetSizeHeight );
% Generate the coordinate to sample from....
Tmp = inv(H) * [a2iX(:), a2iY(:), ones(size(a2iX(:)),1)]';
afX = Tmp(1,:);
afY = Tmp(2,:);
[X,Y]=meshgrid(1:size(I,2),1:size(I,1));
Z = zeros(iTargetSizeHeight,iTargetSizeWidth,3);
for k=1:3
    Z(:,:,k)=reshape(interp2(X,Y,double(I(:,:,k)),afX,afY),size(a2iX))/255;
end
Zn = zeros(2000,1740,3);
Zn(:,741:end,:) = Z;
[Dummy, strFileName, strExt] = fileparts(strFile);
strRectFile = fullfile(strPath,[strFileName,'_rect.bmp']);
imwrite(Zn, strRectFile);
setappdata(handles.figure1,'strOverlayFolder',strPath);
 end
%fnAddSlice(handles,Z, strFullSliceName);
fnAddSlice(handles,I, strFullSliceName);
return;

function fnAddSlice(handles,I, strRectFile)
if 0
prompt={'Enter slice offset in mm:'};
name='Slice position';
numlines=1;
defaultanswer={'0'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return;
end;
end
[strPath,strFile,strExt]=fileparts(strRectFile);


strctAtlas = getappdata(handles.figure1,'strctAtlas');
iNumSlices =  length(strctAtlas.m_astrctSlices);

strctNewSlice.m_strCroppedName = strRectFile;
%strctNewSlice.m_fPositionMM = str2num(answer{1});
strctNewSlice.m_fPositionMM = str2num(strFile)
strctNewSlice.m_acRegions = cell(0);
if iNumSlices  == 0
    strctAtlas.m_astrctSlices = strctNewSlice;
else
    strctAtlas.m_astrctSlices(iNumSlices +1) = strctNewSlice;
end
fnUpdateAtlasStruct(handles.figure1,strctAtlas);

fnUpdateSliceList(handles, iNumSlices +1);
fnSetActiveSlice(handles, iNumSlices +1);
return;

function fnSetActiveSlice(handles, iNewSlice)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
if isempty(strctAtlas.m_astrctSlices)
    return;
end;

strOverlayFolder = getappdata(handles.figure1,'strOverlayFolder');
strFileNameJPGShort = fullfile(strOverlayFolder,sprintf('%04d.jpg', strctAtlas.m_astrctSlices(iNewSlice).m_fPositionMM));
strFileNameJPG = fullfile(strOverlayFolder,sprintf('coronal%d_rect.jpg',round( strctAtlas.m_astrctSlices(iNewSlice).m_fPositionMM)));
strFileNameBMP = fullfile(strOverlayFolder,sprintf('coronal%d_rect.bmp',round( strctAtlas.m_astrctSlices(iNewSlice).m_fPositionMM)));
if ~exist(strFileNameJPG,'file') && ~exist(strFileNameBMP,'file') && ~exist(strFileNameJPGShort,'file')
        I = ones(2000,1740,3,'uint8')*255;
elseif  exist(strFileNameJPG,'file') 
    I=imread(strFileNameJPG);
elseif  exist(strFileNameBMP,'file') 
    I=imread(strFileNameBMP);
elseif exist(strFileNameJPGShort,'file')
    I=imread(strFileNameJPGShort);
end
if size(I,2) == 1000
     J = ones(2000,1740,3,'uint8')*255;
     J(:,741:1740,:) = I;
     I = J;
end

hImage = getappdata(handles.figure1,'hImage');
if isempty(hImage)
    Z = zeros(size(I,1),size(I,2),3);
    hImage = image([],[], Z,'parent',handles.axes1);
    setappdata(handles.figure1,'hImage',hImage);
    axes(handles.axes1);
    hold(handles.axes1,'on');
end

set(hImage,'cdata',I);
% Update region list
fnUpdateSliceRegions(handles);
% Draw Slice Annotation...
bHideRegions = get(handles.hHideRegions,'value');
if ~bHideRegions
    fnUpdateAnnotatedRegions(handles);
else
    a2hRegions= getappdata(handles.figure1,'a2hRegions');
    if ~isempty(a2hRegions)
        delete(a2hRegions(ishandle(a2hRegions)));
    end;
    setappdata(handles.figure1,'a2hRegions',a2hRegions);

end

cla(handles.axes2);
hold(handles.axes2,'on');
for k=1:length(strctAtlas.m_astrctSlices)
    strctAtlas.m_astrctSlices(k).m_fPositionMM
    for j=1:length(strctAtlas.m_astrctSlices(k).m_acRegions)
        plot3(strctAtlas.m_astrctSlices(k).m_acRegions{j}.m_apt2fCoordinates(:,1),strctAtlas.m_astrctSlices(k).m_acRegions{j}.m_apt2fCoordinates(:,2),strctAtlas.m_astrctSlices(k).m_fPositionMM*ones(size(strctAtlas.m_astrctSlices(k).m_acRegions{j}.m_apt2fCoordinates,1),1),'parent',handles.axes2);
    end
end

return;

function fnUpdateAnnotatedRegions(handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveSlice = get(handles.hSlicesList,'value');
iActiveRegion = get(handles.hRegionsInSlice,'value');
if isempty(iActiveRegion) || iActiveSlice > length(strctAtlas.m_astrctSlices)
    iActiveRegion = 1;
    iActiveSlice = 1;
    setappdata(handles.figure1,'iActiveSlice',iActiveSlice);

end;
% Delete existing regions...
a2hRegions= getappdata(handles.figure1,'a2hRegions');
if ~isempty(a2hRegions)
    delete(a2hRegions(ishandle(a2hRegions)));
end;
iNumRegions = length(strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions);
a2hRegions = NaN*ones(2,iNumRegions);
for iRegionIter=1:iNumRegions
    if iRegionIter == iActiveRegion
        afColor = [1 0 0];
    else
        afColor = [0 0 1];
    end
    if ~isempty(strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions{iRegionIter}.m_apt2fCoordinates)
        a2hRegions(1,iRegionIter) = plot(handles.axes1,strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions{iRegionIter}.m_apt2fCoordinates([1:end,1],1),...
            strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions{iRegionIter}.m_apt2fCoordinates([1:end,1],2),'color',afColor,'LineWidth',2,'parent',handles.axes1);
        fX=mean(strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,1));
        fY=mean(strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,2));
        a2hRegions(2,iRegionIter) = text(fX,fY,strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions{iRegionIter}.m_strName,'color',afColor,'parent',handles.axes1);
    end
end
setappdata(handles.figure1,'a2hRegions',a2hRegions);

return;
% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% Save
fnSave(handles.figure1,false);

% --- Executes on button press in hMarkRegion.
function hMarkRegion_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveRegion = get(handles.hRegionsList,'value');
iActiveSlice = get(handles.hSlicesList,'value');
iNumRegions = length(strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions);
strctRegion.m_strName = strctAtlas.m_acRegions{iActiveRegion};
strctRegion.m_apt2fCoordinates = [];
strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iNumRegions+1} = strctRegion;
fnUpdateAtlasStruct(handles.figure1,strctAtlas);
fnUpdateSliceRegions(handles,iNumRegions+1);
[xi, yi, placement_cancelled] = fnMyCreateWaitModePolygon(handles.axes1,'Finish',[],[]);
if placement_cancelled'
     % Remove ?
    return;
end;
strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iNumRegions+1}.m_apt2fCoordinates = [xi, yi];
fnUpdateAtlasStruct(handles.figure1,strctAtlas);
fnUpdateAnnotatedRegions(handles);
return;

function fnUpdateSliceRegions(handles, iSelectedRegion)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveSlice = get(handles.hSlicesList,'value');
iNumRegions = length(strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions);
if iNumRegions == 0
    set(handles.hRegionsInSlice,'visible','off');
else
    set(handles.hRegionsInSlice,'visible','on');
end
acNames = cell(1,iNumRegions);
for k=1:iNumRegions
    acNames{k} = strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{k}.m_strName;
end
if ~exist('iSelectedRegion','var')
    iSelectedRegion = 1;
end
set(handles.hRegionsInSlice,'String',acNames,'value',iSelectedRegion);
return;

% --- Executes on button press in hToggleVisibleRegions.
function hToggleVisibleRegions_Callback(hObject, eventdata, handles)
% hObject    handle to hToggleVisibleRegions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hToggleVisibleRegions


% --- Executes on selection change in hRegionsInSlice.
function hRegionsInSlice_Callback(hObject, eventdata, handles)
 fnUpdateAnnotatedRegions(handles);

% --- Executes during object creation, after setting all properties.
function hRegionsInSlice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hRegionsInSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hModifyRegion.
function hModifyRegion_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveRegion = get(handles.hRegionsInSlice,'value');
iActiveSlice = get(handles.hSlicesList,'value');
if isempty(strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions)
    return;
end;


%  apt2fArcLength= fnResampleArcLength2D(strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iActiveRegion}.m_apt2fCoordinates, 2);
% % 
% afCurvature = LineCurvature2D(strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iActiveRegion}.m_apt2fCoordinates);
% figure;plot(afCurvature)
% fCurvatureThreshold = 0.15;
% aiHighCurvatureVertices = find(afCurvature>fCurvatureThreshold);
% aiSelectedIndices = [1:5:length(afCurvature), 


if isempty(strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iActiveRegion}.m_apt2fCoordinates)
    [xi, yi, placement_cancelled] = fnMyCreateWaitModePolygon(handles.axes1,'Finish',[],[]);
else
[xi, yi, placement_cancelled] = fnMyCreateWaitModePolygon(handles.axes1,'Finish',...
    strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iActiveRegion}.m_apt2fCoordinates(:,1),...
    strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iActiveRegion}.m_apt2fCoordinates(:,2));
end
 if ~placement_cancelled
    strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iActiveRegion}.m_apt2fCoordinates = [xi,yi];
 end
fnUpdateAtlasStruct(handles.figure1,strctAtlas);
 fnUpdateAnnotatedRegions(handles);

% --- Executes on button press in hRemoveRegion.
function hRemoveRegion_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveRegion = get(handles.hRegionsInSlice,'value');
iActiveSlice = get(handles.hSlicesList,'value');
if isempty(strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions)
    return;
end;
strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions(iActiveRegion) = [];

fnUpdateAtlasStruct(handles.figure1,strctAtlas);
 fnUpdateAnnotatedRegions(handles);
 fnUpdateSliceRegions(handles)

return;


% --- Executes on key press with focus on hSearchRegionEdit and none of its controls.
function hSearchRegionEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to hSearchRegionEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hRemoveSlice.
function hRemoveSlice_Callback(hObject, eventdata, handles)
ans=questdlg('Remove Slice?','Warning','Yes','No','No');
if strcmp(ans,'Yes')

strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveSlice = get(handles.hSlicesList,'value');
strctAtlas.m_astrctSlices(iActiveSlice) = [];
fnUpdateAtlasStruct(handles.figure1,strctAtlas);

fnUpdateAnnotatedRegions(handles);
fnUpdateSliceRegions(handles)
fnUpdateSliceList(handles, 1);
fnSetActiveSlice(handles, 1);
end 

return;

% --- Executes on button press in hCopy.
function hCopy_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveSlice = get(handles.hSlicesList,'value');
if ~isempty(strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions)
    setappdata(handles.figure1,'strctCopyRegions',strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions);
    return;
end;
return;


% --- Executes on button press in hPaste.
function hPaste_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveSlice = get(handles.hSlicesList,'value');
strctCopyRegions = getappdata(handles.figure1,'strctCopyRegions');
if isempty(strctCopyRegions)
    return;
end;

ans=questdlg('Paste','Warning','Yes','No','Yes');
if strcmp(ans,'Yes')
    strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions = strctCopyRegions;
    fnUpdateAtlasStruct(handles.figure1,strctAtlas);
     fnUpdateAnnotatedRegions(handles);
    fnUpdateSliceRegions(handles)

    return;
end;


% --- Executes on button press in hSetOverlay.
function hSetOverlay_Callback(hObject, eventdata, handles)
strOverlayFolder =uigetdir();
if strOverlayFolder(1) == 0
    return;
end;
setappdata(handles.figure1,'strOverlayFolder',strOverlayFolder);
iActiveSlice = get(handles.hSlicesList,'value');
fnSetActiveSlice(handles, iActiveSlice);

% fnUpdateAnnotatedRegions(handles);
% fnUpdateSliceRegions(handles)


% --- Executes on selection change in hMetaRegionList.
function hMetaRegionList_Callback(hObject, eventdata, handles)
 fnUpdateMetaList(handles,get(hObject,'value'));
return;
% --- Executes during object creation, after setting all properties.
function hMetaRegionList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hMetaRegionList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hNewMetaRegion.
function hNewMetaRegion_Callback(hObject, eventdata, handles)
% hObject    handle to hNewMetaRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
strctAtlas = getappdata(handles.figure1,'strctAtlas');

prompt={'Enter new meta-region:'};
name='New meta-region name';
numlines=1;
defaultanswer={''};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return;
end;

if ~isfield(strctAtlas,'m_astrctMetaRegions')
    iNewRegion = 1;
else
    iNewRegion = length(strctAtlas.m_astrctMetaRegions)+1;
end
strctAtlas.m_astrctMetaRegions(iNewRegion).m_strName = answer{1};
strctAtlas.m_astrctMetaRegions(iNewRegion).m_acRegions = {};

fnUpdateAtlasStruct(handles.figure1,strctAtlas);

fnUpdateMetaList(handles,iNewRegion)
return;

function hRemoveMetaRegion_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
ans=questdlg('Remove?','Warning','Yes','No','Yes');
iActiveMetaRegion = get(handles.hMetaRegionList,'value');
if strcmp(ans,'Yes') && length(strctAtlas.m_astrctMetaRegions) >= iActiveMetaRegion
    strctAtlas.m_astrctMetaRegions(iActiveMetaRegion) = [];
    fnUpdateAtlasStruct(handles.figure1,strctAtlas);
    fnUpdateMetaList(handles,0)
end
return;

function hIncludeRegionsInMetaRegion_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveMetaRegion = get(handles.hMetaRegionList,'value');

aiRegionsToInclude = get(handles.hMetaRegionExclude,'value');
acRegionsFromExcludeList = get(handles.hMetaRegionExclude,'string');

strctAtlas.m_astrctMetaRegions(iActiveMetaRegion).m_acRegions = ...
    [strctAtlas.m_astrctMetaRegions(iActiveMetaRegion).m_acRegions; acRegionsFromExcludeList(aiRegionsToInclude)];

set(handles.hMetaRegionExclude,'value',1);
fnUpdateAtlasStruct(handles.figure1,strctAtlas);

fnUpdateMetaList(handles,iActiveMetaRegion)
return;


function hExcludeRegionsFromMetaRegion_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveMetaRegion = get(handles.hMetaRegionList,'value');

aiRegionsToExclude = get(handles.hMetaRegionInclude,'value');
acRegionsFromIncludeList = get(handles.hMetaRegionInclude,'string');

strctAtlas.m_astrctMetaRegions(iActiveMetaRegion).m_acRegions = setdiff(strctAtlas.m_astrctMetaRegions(iActiveMetaRegion).m_acRegions,...
    acRegionsFromIncludeList(aiRegionsToExclude));

set(handles.hMetaRegionInclude,'value',1);
fnUpdateAtlasStruct(handles.figure1,strctAtlas);

fnUpdateMetaList(handles,iActiveMetaRegion)
return;


% --- Executes on selection change in hMetaRegionExclude.
function hMetaRegionExclude_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function hMetaRegionExclude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hMetaRegionExclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in hMetaRegionInclude.
function hMetaRegionInclude_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function hMetaRegionInclude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hMetaRegionInclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in hHideRegions.
function hHideRegions_Callback(hObject, eventdata, handles)
iActiveSlice = get(handles.hSlicesList,'value');

fnSetActiveSlice(handles, iActiveSlice)

% --- Executes on button press in hDuplicateBilateral.
function hDuplicateBilateral_Callback(hObject, eventdata, handles)
% hObject    handle to hDuplicateBilateral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hDuplicateBilateral


function fnUpdateMetaList(handles,iSelectedMetaRegion)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
if isfield(strctAtlas,'m_astrctMetaRegions')
    set(handles.hMetaRegionList,'String',{strctAtlas.m_astrctMetaRegions.m_strName},'value',iSelectedMetaRegion);
    % Update list...
    if ~isempty( strctAtlas.m_astrctMetaRegions)
        acCanAdd = setdiff(strctAtlas.m_acRegions,  strctAtlas.m_astrctMetaRegions(iSelectedMetaRegion).m_acRegions);
        set(handles.hMetaRegionInclude, 'string', strctAtlas.m_astrctMetaRegions(iSelectedMetaRegion).m_acRegions,'min',1,'max',length(strctAtlas.m_astrctMetaRegions(iSelectedMetaRegion).m_acRegions));
        set(handles.hMetaRegionExclude, 'string', acCanAdd,'min',1,'max',length(acCanAdd));
    else
        set(handles.hMetaRegionInclude, 'string', {});
        set(handles.hMetaRegionExclude, 'string', {});
    end
end
return;

function fnUpdateRegionList(handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
set(handles.hRegionsList,'String',strctAtlas.m_acRegions,'value',1);
return;


function hReconstruct3D_Callback(hObject, eventdata, handles)
bDuplicateBilateral = get(handles.hDuplicateBilateral,'value');
strctAtlas = getappdata(handles.figure1,'strctAtlas');
strctAtlas = fnConvertAtlasPolygonsToMesh(strctAtlas,bDuplicateBilateral);
fnUpdateAtlasStruct(handles.figure1,strctAtlas)
return;

function fnUpdateAtlasStruct(hFigure1,strctAtlas)
setappdata(hFigure1,'strctAtlas',strctAtlas);
setappdata(hFigure1,'bChanged',true);
return;


function fnLoadAtlasFile(handles, strFile, bFirstTime)
if ~exist(strFile,'file')
       if bFirstTime
            strctAtlas.m_astrctSlices= [];
            strctAtlas.m_acRegions = {};
            setappdata(handles.figure1,'strctAtlas',strctAtlas);
       end
       return;
end

setappdata(handles.figure1,'strCurrentAtlasFile',strFile);
% Load settings....
load(strFile);
% Sort slices....

if ~isfield(strctAtlas,'m_afXPixelToMM')
    % Old version....
    % Add 740 to all regions (old version did not have bi-lateral
    % support)
    
    afY = 1:2000;
    afX = 1:1740;
    strctAtlas.m_afXPixelToMM = afX* 0.0431   -37.5074;
    strctAtlas.m_afYPixelToMM = afY * -0.0425  + 68.1806;
    
    for k=1:length(strctAtlas.m_astrctSlices)
        for j=1:length(strctAtlas.m_astrctSlices(k).m_acRegions)
            if ~isempty(strctAtlas.m_astrctSlices(k).m_acRegions{j}.m_apt2fCoordinates)
                strctAtlas.m_astrctSlices(k).m_acRegions{j}.m_apt2fCoordinates(:,1) = strctAtlas.m_astrctSlices(k).m_acRegions{j}.m_apt2fCoordinates(:,1)+740;
            end
        end
    end
end
[afDummy,aiInd]=sort(cat(1,strctAtlas.m_astrctSlices.m_fPositionMM));
strctAtlas.m_astrctSlices = strctAtlas.m_astrctSlices(aiInd);


setappdata(handles.figure1,'strctAtlas',strctAtlas);
% Set lists....
warning off
Tmp = get(handles.axes1,'position');
%Z = zeros(length( strctAtlas.m_afYPixelToMM), length(strctAtlas.m_afXPixelToMM),3);
%Z = zeros(Tmp(3), Tmp(4),3);
Z = zeros(1536,2048,3);
hImage = image([],[], Z,'parent',handles.axes1);
set(handles.axes1,'Visible','off');
hold(handles.axes1,'on');
setappdata(handles.figure1,'hImage',hImage);

fnUpdateMetaList(handles,1);
fnUpdateSliceList(handles, 1);
fnUpdateRegionList(handles);
fnSetActiveSlice(handles, 1);

setappdata(handles.figure1,'bChanged',false);

return;


% --------------------------------------------------------------------
function hOpenAtlasFile_ClickedCallback(hObject, eventdata, handles)
[strFile,strPath]=uigetfile('Atlas.mat');
if strPath(1)==0
    return;
end;

fnLoadAtlasFile(handles, fullfile(strPath,strFile), false);
return;


% --- Executes on button press in hReassignID.
function hReassignID_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveSlice = get(handles.hSlicesList,'value');
iActiveRegion = get(handles.hRegionsInSlice,'value');


X=listdlg('ListString',strctAtlas.m_acRegions);
if ~isempty(X)
    strctAtlas.m_astrctSlices(iActiveSlice).m_acRegions{iActiveRegion}.m_strName = strctAtlas.m_acRegions{X};
end

fnUpdateAtlasStruct(handles.figure1,strctAtlas);
fnUpdateRegionList(handles);
fnUpdateSliceRegions(handles);
fnUpdateAnnotatedRegions(handles);

return;


% --- Executes on button press in hAddOuterSurface.
function hAddOuterSurface_Callback(hObject, eventdata, handles)
fnAddOuterSurface(handles);



function fnAddOuterSurface(handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');

strRegionName = 'Outer Surface';
iNumSlices = length(strctAtlas.m_astrctSlices);
iSliceIter = getappdata(handles.figure1,'iActiveSlice');
% for iSliceIter=1:iNumSlices
    iNumRegionsInSlice = length(strctAtlas.m_astrctSlices(iSliceIter ).m_acRegions);
    apt2fAllCoordinates = [];
    acRegionNamesInSlice = cell(1,iNumRegionsInSlice);
    for k=1:iNumRegionsInSlice
        if ~strcmpi(acRegionNamesInSlice{k}, strRegionName)
            acRegionNamesInSlice{k} = strctAtlas.m_astrctSlices(iSliceIter ).m_acRegions{k}.m_strName;
            apt2fAllCoordinates = [apt2fAllCoordinates;...
                strctAtlas.m_astrctSlices(iSliceIter ).m_acRegions{k}.m_apt2fCoordinates];
        end
    end
    
    aiIndices=convhull(apt2fAllCoordinates(:,1),apt2fAllCoordinates(:,2));
    apt2fConvexHull =apt2fAllCoordinates(aiIndices,:);
    apt2fConvexHullArcLength =fnResampleArcLength2D(apt2fConvexHull, 10);

    iIndex= find(ismember(acRegionNamesInSlice,strRegionName));
    
    if isempty(iIndex)
        iIndex = iNumRegionsInSlice+1;
    end
    strctConvex.m_strName =strRegionName ;
    strctConvex.m_apt2fCoordinates = apt2fConvexHullArcLength;
    strctAtlas.m_astrctSlices(iSliceIter ).m_acRegions{iIndex} = strctConvex;
% end
if isempty(find(ismember(strctAtlas.m_acRegions,strRegionName)))
    strctAtlas.m_acRegions{end+1} = strRegionName;
end
fnUpdateAtlasStruct(handles.figure1,strctAtlas);
 fnUpdateAnnotatedRegions(handles);
return;


% --- Executes on button press in hModifyRegion2.
function hModifyRegion2_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveRegion = get(handles.hRegionsInSlice,'value');
iActiveSlice = get(handles.hSlicesList,'value');
if isempty(strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions)
    return;
end;
[xi, yi ] = fnMyPolygonModificationTool(handles.axes1,...
    strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iActiveRegion}.m_apt2fCoordinates(:,1),...
    strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iActiveRegion}.m_apt2fCoordinates(:,2));
strctAtlas.m_astrctSlices(iActiveSlice ).m_acRegions{iActiveRegion}.m_apt2fCoordinates = [xi,yi];
 fnUpdateAtlasStruct(handles.figure1,strctAtlas);
 fnUpdateAnnotatedRegions(handles);

 


% --- Executes on button press in hSingleVolumeReconstruction.
function hSingleVolumeReconstruction_Callback(hObject, eventdata, handles)
dbg = 1;
bDuplicateBilateral = get(handles.hDuplicateBilateral,'value');
strctAtlas = getappdata(handles.figure1,'strctAtlas');


[afSortedValues, aiInd]=sort(cat(1,strctAtlas.m_astrctSlices.m_fPositionMM));
astrctSortedSlices = strctAtlas.m_astrctSlices(aiInd);

afMLrange = strctAtlas.m_afXPixelToMM;
afDVrange = strctAtlas.m_afYPixelToMM;

%% Build Volume?

afAPpos = cat(1,astrctSortedSlices.m_fPositionMM);
iNumAPslices = max(afAPpos) - min(afAPpos)+2+1; % Adding two more to allow closed surfaces?
a3iAtlasVolume = zeros(length(afDVrange), length(afMLrange), iNumAPslices,'uint16');
bDuplicateBilateral = false;
clear astrctMesh
 h = waitbar(0,'Reconstructing regions...');
 iCounter=1;
 iNumRegions = length(strctAtlas.m_acRegions);
 for k=1:length(strctAtlas.m_acRegions)
    waitbar(k/length(strctAtlas.m_acRegions),h);
    fprintf('%d out of %d (%s) \n',k,length(strctAtlas.m_acRegions),strctAtlas.m_acRegions{k});
    a3bVolumeOfInterest = fnBinarizeRegionOfInterest(strctAtlas.m_acRegions{k},astrctSortedSlices,{strctAtlas.m_acRegions{k}},bDuplicateBilateral,0,false,afMLrange,afDVrange);
    if ~isempty(a3bVolumeOfInterest)
        a3iAtlasVolume(a3bVolumeOfInterest) = k; % (Override).
        iCounter=iCounter+1;
    end
 end

  for k=1:length(strctAtlas.m_acRegions)
    waitbar(k/length(strctAtlas.m_acRegions),h);
    fprintf('%d out of %d (%s) \n',k,length(strctAtlas.m_acRegions),strctAtlas.m_acRegions{k});
    a3bVolumeOfInterest = fnBinarizeRegionOfInterest(strctAtlas.m_acRegions{k},astrctSortedSlices,{strctAtlas.m_acRegions{k}},bDuplicateBilateral,0,true,afMLrange,afDVrange);
    if ~isempty(a3bVolumeOfInterest)
        a3iAtlasVolume(a3bVolumeOfInterest) = iNumRegions+k; 
        iCounter=iCounter+1;
    end
  end
 
delete(h);

% CRS_TO_XYZ maps volume indices starting at ZERO(!) to mm space
%[0,0,0] -> [ afMLrange(1),afDVrange(1),afAPpos(1)-1]
%[length(afMLrange)-1] - > afMLrange(end)

fMLScale  = (afMLrange(end)-afMLrange(1))/(length(afMLrange)-1);
fDVScale  = (afDVrange(end)-afDVrange(1))/(length(afDVrange)-1);

a2fCRS_TO_XYZ = [fMLScale  0 0 afMLrange(1)
                                  0 fDVScale 0 afDVrange(1)
                                  0 0 1 afAPpos(1)-1
                                  0 0 0 1];

acRegionNames = cell(1,2*length(strctAtlas.m_acRegions));
for k=1:length(strctAtlas.m_acRegions)
    acRegionNames{k} = ['LH ',strctAtlas.m_acRegions{k}];
    acRegionNames{iNumRegions+k} = ['RH ',strctAtlas.m_acRegions{k}];
end
                              
save('AtlasVolume','a3iAtlasVolume','a2fCRS_TO_XYZ','acRegionNames');
%                               
% a2fCRS_TO_XYZ * [872,1307,5,1]'
% dbg = 1;
% fnVolumeViewer(a3iAtlasVolume)


% --- Executes on button press in RenameRegion.
function RenameRegion_Callback(hObject, eventdata, handles)
strctAtlas = getappdata(handles.figure1,'strctAtlas');
iActiveRegion = get(handles.hRegionsList,'value');
if isempty(strctAtlas.m_acRegions)
    return;
end;
prompt={'Enter new name:'};

name='New brain region name';
numlines=1;
defaultanswer={''};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return;
end;
strNewName= answer{1};
strOldName = strctAtlas.m_acRegions{iActiveRegion};
strctAtlas.m_acRegions{iActiveRegion} = strNewName;
for k=1:length(strctAtlas.m_astrctSlices)
    for j=1:length(strctAtlas.m_astrctSlices(k).m_acRegions)
        if strcmpi(strctAtlas.m_astrctSlices(k).m_acRegions{j}.m_strName,strOldName)
            strctAtlas.m_astrctSlices(k).m_acRegions{j}.m_strName = strNewName;
        end
    end
end

fnUpdateAtlasStruct(handles.figure1,strctAtlas);
fnUpdateRegionList(handles);


% --- Executes on button press in hMoveUp.
function hMoveUp_Callback(hObject, eventdata, handles)
% hObject    handle to hMoveUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hMoveDown.
function hMoveDown_Callback(hObject, eventdata, handles)
% hObject    handle to hMoveDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hMoveLeft.
function hMoveLeft_Callback(hObject, eventdata, handles)
% hObject    handle to hMoveLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hMoveRight.
function hMoveRight_Callback(hObject, eventdata, handles)
% hObject    handle to hMoveRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hRotateLeft.
function hRotateLeft_Callback(hObject, eventdata, handles)
% hObject    handle to hRotateLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hRotateRight.
function hRotateRight_Callback(hObject, eventdata, handles)
% hObject    handle to hRotateRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hScaleUp.
function hScaleUp_Callback(hObject, eventdata, handles)
% hObject    handle to hScaleUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hScaleDown.
function hScaleDown_Callback(hObject, eventdata, handles)
% hObject    handle to hScaleDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
