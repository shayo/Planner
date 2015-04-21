function GridMeasureCallback(strCallback, varargin)
global g_strctWindows g_strctModule
switch strCallback
    case 'MouseMove'
        strctMouseOp = varargin{1};
        fnMouseMove(strctMouseOp);
    case 'MouseUp'
        strctMouseOp = varargin{1};
        fnMouseUp(strctMouseOp);
    case 'MouseDown'
        strctMouseOp = varargin{1};
        fnMouseDown(strctMouseOp);
    case 'MouseWheel'
        strctMouseOp = varargin{1};
        %fnMouseWheel(strctMouseOp);
    case 'Invalidate'
        fnInvalidate();
    case 'SetPanMode'
        fnSetPanMode();
    case 'SetZoomMode'
        fnSetZoomMode();
    case 'SetScaleXMode'
        fnSetScaleXMode();
    case 'SetScaleYMode'
        fnSetScaleYMode();
    case 'SetRotateMode'
        fnSetRotateMode();
    case 'SetMoveMode'
        fnSetMoveMode();
    case 'SelectGrid'
        fnSelectGrid();
    case 'AddHole'
        fnAddHole();
    case 'MoveHole'
        fnMoveHole();
    case 'AddNewGrid'
        fnAddNewGrid();
    case 'LoadFront'
        fnLoadFront();
    case 'LoadBack'
        fnLoadBack();
    case 'RenameGrid'
        fnRenameGrid();
    case 'RemoveGrid'
        fnRemoveGrid();
    case 'SaveSession'
        fnSaveSession();
    case 'LoadSession'
        fnLoadSession();
    case 'ResizeToMetric'
        fnResizeToMetric();
    case 'ResetView'
        fnResetView();
    case 'PanGrid'
        fnPanGrid();
    case 'ShowHideHoles'
        fnShowHideHoles();
    case 'SetFullGrid'
        fnSetFullGrid();
    case 'RemoveHole'
        fnRemoveHole();
    case 'ExportGrid'
        fnExportGrid();
end

return;


function fnAddHole()
global g_strctModule
switch g_strctModule.m_strctMouseOpMenu.m_hAxes
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        strctCurrGrid = g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid};
        iNumHoles = length(strctCurrGrid.m_afFrontHoleX);
        
          aiSize = size((strctCurrGrid.m_a3fFrontImage));
                pt2fCenter = [(aiSize(2)-1)/2, (aiSize(1)-1)/2;];
                pt2fPosMM =  [g_strctModule.m_strctMouseOpMenu.m_pt2fPos(1) - pt2fCenter(1), ...
                    g_strctModule.m_strctMouseOpMenu.m_pt2fPos(2)-pt2fCenter(2) ] / strctCurrGrid.m_MM_To_Pix;
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleX(iNumHoles+1) = pt2fPosMM(1);
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleY(iNumHoles+1) = pt2fPosMM(2);
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
 end
fnInvalidate();
return;


function fnExportGrid()
global g_strctModule
strctCurrGrid =  g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid};
[strFile, strPath] = uiputfile([strctCurrGrid.m_strName,'.mat']);
if strFile(1) == 0
    return;
end;

abValid = sqrt(strctCurrGrid.m_afFrontHoleX.^2 + strctCurrGrid.m_afFrontHoleY.^2) <=  strctCurrGrid.m_fRadiusMM;
iNumGridHoles = sum(abValid);

strctCurrGrid.m_afFrontHoleX = strctCurrGrid.m_afFrontHoleX(abValid);
strctCurrGrid.m_afFrontHoleY = strctCurrGrid.m_afFrontHoleY(abValid);
strctGridParam.m_strGridName = strctCurrGrid.m_strName;
strctGridParam.m_fGridPhiDeg = 5; 
strctGridParam.m_fGridInnerDiameterMM = strctCurrGrid.m_fRadiusMM*2;
strctGridParam.m_fGridHoleDiameterMM = strctCurrGrid.m_fHoleDiameterMM;
strctGridParam.m_fGridHoleDistanceMM = strctCurrGrid.m_fHoleDistanceMM;
strctGridParam.m_fGridHeightMM = 10;
strctGridParam.m_afGridX = strctCurrGrid.m_afFrontHoleX';
strctGridParam.m_afGridY = -strctCurrGrid.m_afFrontHoleY';
[fNormalY,fNormalX, fNormalZ] = sph2cart(0, -(90-strctGridParam.m_fGridPhiDeg)/180*pi, 1);
strctGridParam.m_apt3fGridNormals = repmat([fNormalX;fNormalY;fNormalZ],1,iNumGridHoles)';
strctGridParam.m_fGridThetaDeg = 0; % Relative to chamber
strctGridParam.m_abSelected = zeros(1, length(strctGridParam.m_afGridX))>0;
strctGridParam.m_afGuideTubeLengthMM = 20*ones(1, length(strctGridParam.m_afGridX));
strctGridParam.m_afElectrodeLengthMM = 60*ones(1, length(strctGridParam.m_afGridX));
save([strPath, strFile],'strctGridParam');
return;


function fnMoveHole()
global g_strctModule
g_strctModule.m_strMouseMode = 'MoveHole';

return;

function fnShowHideHoles()
global g_strctModule
strctCurrGrid =  g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid};
strctCurrGrid
return;

function fnRemoveHole()
global g_strctModule
strctCurrGrid =  g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid};
aiSize = size(strctCurrGrid.m_a3fFrontImage);
pt2fCenter = [(aiSize(2)-1)/2, (aiSize(1)-1)/2;];

pt2fPosMM =  [g_strctModule.m_strctMouseOpMenu.m_pt2fPos(1) - pt2fCenter(1), ...
    g_strctModule.m_strctMouseOpMenu.m_pt2fPos(2)-pt2fCenter(2) ] / strctCurrGrid.m_MM_To_Pix;

switch g_strctModule.m_strctMouseOpMenu.m_hAxes
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        iSelectedHole = find(sqrt((strctCurrGrid.m_afFrontHoleX-pt2fPosMM(1)).^2 + (strctCurrGrid.m_afFrontHoleY-pt2fPosMM(2)).^2) < (strctCurrGrid.m_fHoleDiameterMM/2));
        
        if ~isempty(iSelectedHole)
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleX(iSelectedHole) = [];
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleY(iSelectedHole) = [];
            if ishandle(g_strctModule.m_hCurrHole)
                delete(g_strctModule.m_hCurrHole);
                g_strctModule.m_hCurrHole = [];
            end
        end;
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        iSelectedHole = find(sqrt((strctCurrGrid.m_afFrontBackX-pt2fPosMM(1)).^2 + (strctCurrGrid.m_afFrontBackY-pt2fPosMM(2)).^2) < (strctCurrGrid.m_fHoleDiameterMM/2));
        if ~isempty(iSelectedHole)
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleX(iSelectedHole) = [];
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleY(iSelectedHole) = [];
            if ishandle(g_strctModule.m_hCurrHole)
                delete(g_strctModule.m_hCurrHole);
                g_strctModule.m_hCurrHole = [];
            end
        end
end
fnInvalidate();

return;

function fnRemoveGrid()
global g_strctModule
g_strctModule.m_acGrids(g_strctModule.m_iCurrGrid) = [];
g_strctModule.m_iCurrGrid = length(g_strctModule.m_iCurrGrid);
fnUpdateGridList();
fnInvalidate(1);
fnSetAxis();
return;

function fnPanGrid()
global g_strctModule
g_strctModule.m_strMouseMode = 'PanGrid';
return;

function fnResetView()
global g_strctModule
fnInvalidate(1);

switch g_strctModule.m_strctMouseOpMenu.m_hAxes
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        fnResetAxis(1,0);
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        fnResetAxis(0,1);
end;


return;

function fnRenameGrid()
global g_strctModule
strOldName = g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strName;
answer=inputdlg({'New Grid Name:'},'Change Grid Name',1,{strOldName});
if isempty(answer)
    return;
end;
g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strName = answer{1};
fnUpdateGridList();
return;

function a3fNewImage=fnResampleEllipse(iNewResolution,strctEllipse, a3fI)
aiRange = linspace(-1,1,iNewResolution);
[a2fX, a2fY] = meshgrid(aiRange,aiRange);
a2fP = [a2fX(:)';a2fY(:)';ones(size(a2fX(:)'))];
a2fRot = [cos(strctEllipse.m_fOrientationDeg/180*pi), sin(strctEllipse.m_fOrientationDeg/180*pi),0;
        -sin(strctEllipse.m_fOrientationDeg/180*pi) cos(strctEllipse.m_fOrientationDeg/180*pi),0;
        0 0 1];
    
a2fScale = [strctEllipse.m_fRadiusA 0 ,0;
             0                       strctEllipse.m_fRadiusB,0;
             0,0,1];
         
a2fTrans = [1 0 strctEllipse.m_pt2fCenter(1);
            0 1 strctEllipse.m_pt2fCenter(2);
            0,0, 1];

a2fM = (a2fTrans*a2fScale*a2fRot);
Tmp = a2fM * a2fP;
a3fNewImage = zeros([iNewResolution,iNewResolution,3]);
a3fNewImage(:,:,1) = reshape(interp2(a3fI(:,:,1),Tmp(1,:),Tmp(2,:)),[iNewResolution,iNewResolution]);
a3fNewImage(:,:,2) = reshape(interp2(a3fI(:,:,2),Tmp(1,:),Tmp(2,:)),[iNewResolution,iNewResolution]);
a3fNewImage(:,:,3)= reshape(interp2(a3fI(:,:,3),Tmp(1,:),Tmp(2,:)),[iNewResolution,iNewResolution]);
return;


function fnResizeToMetric()
global g_strctModule
iNewResolution = 513;
fDefaultInnerRadiusMM = 16.6;
fDefaultOuterDiameterMM = 18.8;

switch g_strctModule.m_strctMouseOpMenu.m_hAxes
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        answer=inputdlg({'New Grid Diameter (mm):'},...
            'Metric!',1,{num2str(fDefaultInnerRadiusMM)});
        if isempty(answer)
            return;
        end;
        fDiameterMM = str2num(answer{1});
       a3fNewImage=fnResampleEllipse(iNewResolution,...
          g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse,...
          g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_a3fFrontImage);
      
      strctNewEllipse.m_fRadiusA = iNewResolution/2;
      strctNewEllipse.m_fRadiusB = iNewResolution/2;
      strctNewEllipse.m_fOrientationDeg = 0;
      strctNewEllipse.m_pt2fCenter = [iNewResolution/2,iNewResolution/2];
  
      
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_MM_To_Pix = iNewResolution/fDiameterMM;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_fRadiusMM = fDiameterMM/2;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_a3fFrontImage = a3fNewImage;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse = strctNewEllipse;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange = [0 iNewResolution 0 iNewResolution];
      
      
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        answer=inputdlg({'New Grid Diameter (mm):'},...
            'Metric!',1,{num2str(fDefaultOuterDiameterMM)});
        if isempty(answer)
            return;
        end;
        fDiameterMM = str2num(answer{1});
         
       a3fNewImage=fnResampleEllipse(iNewResolution,...
          g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse,...
          g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_a3fBackImage);

      strctNewEllipse.m_fRadiusA = iNewResolution/2;
      strctNewEllipse.m_fRadiusB = iNewResolution/2;
      strctNewEllipse.m_fOrientationDeg = 0;
      strctNewEllipse.m_pt2fCenter = [iNewResolution/2,iNewResolution/2];
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_fRadiusMM = fDiameterMM/2;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_a3fBackImage = a3fNewImage;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse = strctNewEllipse;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange = [0 iNewResolution 0 iNewResolution];
end;
    

fnInvalidate(1);
fnSetAxis();
return;

function fnSetFullGrid()
global g_strctModule

switch g_strctModule.m_strctMouseOpMenu.m_hAxes
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes

iNewResolution = size(g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_a3fFrontImage,1);
fDefaultHoleDiameterMM = 0.67;
fDefaultHoleDistanceMM = 1;
     answer=inputdlg({'Hole Diameter (mm):','Hole Distance (mm):'},...
            'Metric!',1,{num2str(fDefaultHoleDiameterMM),num2str(fDefaultHoleDistanceMM)});
        if isempty(answer)
            return;
        end;
        fHoleDiameterMM = str2num(answer{1});
        fHoleDistanceMM = str2num(answer{2});
        
        fDiameterMM = 2*g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_fRadiusMM;
      fMM_To_Pix = iNewResolution/fDiameterMM;
      afXCentersMM = [fliplr(-fHoleDistanceMM:-fHoleDistanceMM:-fDiameterMM/2 + fHoleDiameterMM),...
          0:fHoleDistanceMM:fDiameterMM/2 - fHoleDiameterMM];
      afYCentersMM = afXCentersMM;
      [a2fXc, a2fYc] = meshgrid(afXCentersMM, afYCentersMM);
      a2bFeasible =  sqrt(a2fXc.^2 + a2fYc.^2) < fDiameterMM/2 - fHoleDiameterMM;
      
      afFrontHoleXmm = a2fXc(a2bFeasible)';
      afFrontHoleYmm = a2fYc(a2bFeasible)';
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleX = afFrontHoleXmm;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleY = afFrontHoleYmm;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_fHoleDistanceMM = fHoleDistanceMM;
      g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_fHoleDiameterMM = fHoleDiameterMM;
      
     
end
fnInvalidate(1);

return;


function fnSaveSession()
global g_strctModule
[strFile,strPath] = uiputfile('GridMeasureSession.mat','Select file to save session');
if strFile(1) == 0
    return;
end;

save([strPath,strFile],'g_strctModule');
return;

function fnLoadSession()
global g_strctModule
[strFile,strPath] = uigetfile('*.mat','Select file to load session');
if strFile(1) == 0
    return;
end;
strctTmp = load([strPath,strFile]);
g_strctModule.m_acGrids = strctTmp.g_strctModule.m_acGrids();
g_strctModule.m_iCurrGrid = strctTmp.g_strctModule.m_iCurrGrid;
g_strctModule.m_strctGUIOptions = strctTmp.g_strctModule.m_strctGUIOptions;

fnUpdateGridList();

fnInvalidate(1);

fnSetAxis();
return;


function fnSetMoveMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Move';
return;

function fnSetRotateMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Rotate';
return;

function fnSetPanMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Pan';
return;

function fnSetScaleXMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'ScaleX';
return;


function fnSetScaleYMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'ScaleY';
return;

function fnSetZoomMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Zoom';
return;

function fnAddNewGrid()
global g_strctModule

strctGrid.m_a3fFrontImage = [];
strctGrid.m_a3fBackImage = [];
strctGrid.m_strName = 'Unknown';

strctEllipse.m_pt2fCenter = [0 0 ];
strctEllipse.m_fRadiusA = 0;
strctEllipse.m_fRadiusB = 0;
strctEllipse.m_fOrientationDeg = 0;

strctGrid.m_fRadiusMM = -1; 
strctGrid.m_fHoleDiameterMM = -1;
strctGrid.m_fHoleDistanceMM = -1;
strctGrid.m_afFrontHoleX = [];
strctGrid.m_afFrontHoleY = [];
strctGrid.m_afBackHoleX = [];
strctGrid.m_afBackHoleY = [];

strctGrid.m_afFrontGridOffset = [];
strctGrid.m_afBackGridOffset = [];


strctGrid.m_strctFrontEllipse = strctEllipse;
strctGrid.m_strctBackEllipse = strctEllipse;

strctGrid.m_aiFrontAxisRange = [0 1 0 1];
strctGrid.m_aiBackAxisRange = [0 1 0 1];

iNumGrids = length(g_strctModule.m_acGrids);
g_strctModule.m_acGrids{iNumGrids+1} = strctGrid;
g_strctModule.m_iCurrGrid = iNumGrids+1;
fnUpdateGridList();
return;

function fnLoadFront()
global g_strctModule
if g_strctModule.m_iCurrGrid == 0
    return;
end

[strFile,strPath]=uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.jpg'],'Select fron photo of grid');
if strFile(1) == 0
    return;
end
I = im2double(imread([strPath,strFile]));

g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_a3fFrontImage = I;

g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_pt2fCenter = [size(I,2),size(I,1)]/2;
g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_fRadiusA = size(I,1)/4;
g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_fRadiusB = size(I,1)/4;
g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_fOrientationDeg = 0;


fnInvalidate(1);
fnResetAxis(1,0);

return;


function fnLoadBack()
global g_strctModule
if g_strctModule.m_iCurrGrid == 0
    return;
end

[strFile,strPath]=uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.jpg'],'Select fron photo of grid');
if strFile(1) == 0
    return;
end
I = im2double(imread([strPath,strFile]));

g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_a3fBackImage = I;

g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_pt2fCenter = [size(I,2),size(I,1)]/2;
g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_fRadiusA = size(I,1)/4;
g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_fRadiusB = size(I,1)/4;
g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_fOrientationDeg = 0;


fnInvalidate(1);
fnResetAxis(0,1);
return;

function fnResetAxis(bFront,bBack)
global g_strctModule

if bFront
    aiFrontSize = size(g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_a3fFrontImage);
    iZoomFront = min(aiFrontSize(1)/2, aiFrontSize(2)/2);
    g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange = [aiFrontSize(2)/2-iZoomFront,aiFrontSize(2)/2+iZoomFront,...
        aiFrontSize(1)/2-iZoomFront,aiFrontSize(1)/2+iZoomFront];
    
    set(g_strctModule.m_strctPanel.m_strctFront.m_hAxes, 'Xlim',...
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange(1:2),...
        'ylim',g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange(3:4));
end;

if bBack
    aiBackSize = size(g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_a3fBackImage);
    iZoomBack = min(aiBackSize(1)/2, aiBackSize(2)/2);
    g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange = [aiBackSize(2)/2-iZoomBack,aiBackSize(2)/2+iZoomBack,...
        aiBackSize(1)/2-iZoomBack,aiBackSize(1)/2+iZoomBack];
    
    set(g_strctModule.m_strctPanel.m_strctBack.m_hAxes, 'Xlim',...
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange(1:2),...
        'ylim',g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange(3:4));
end;

return;


function fnSelectGrid()
global g_strctModule
g_strctModule.m_iCurrGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
fnInvalidate(1);
fnResetAxis(1,1);
return;

function fnUpdateGridList()
global g_strctModule

strList = '';
iNumGrids = length(g_strctModule.m_acGrids);
for iGridIter=1:iNumGrids
    strList = [strList,'|',g_strctModule.m_acGrids{iGridIter}.m_strName];
end;
if iNumGrids == 0
    set(g_strctModule.m_strctPanel.m_hGridList,'string','','value',1);
else
    set(g_strctModule.m_strctPanel.m_hGridList,'string',strList(2:end),'value',g_strctModule.m_iCurrGrid);
end;
return;

function fnPanImage(hAxes, afDelta)
global g_strctModule
switch hAxes
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange + afDelta([1,1,2,2]);
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange + afDelta([1,1,2,2]);

end
fnSetAxis();
return;

function fnSetAxis()
global g_strctModule
if g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange(2) > g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange(1) && ...
   g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange(4) > g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange(3)
set(g_strctModule.m_strctPanel.m_strctFront.m_hAxes, 'Xlim',...
       g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange(1:2),...
        'ylim',g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange(3:4));
           
    
end;

if g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange(2) > g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange(1) && ...
   g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange(4) > g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange(3) 

set(g_strctModule.m_strctPanel.m_strctBack.m_hAxes, 'Xlim',...
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange(1:2),...
        'ylim',g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange(3:4));
end;
return;



function fnZoomImage(hAxes, afDelta)
global g_strctModule
[fDummy,iIndex] = max(abs(afDelta));
fZoom = afDelta(iIndex);
switch hAxes
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
       g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange = ...
           g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiBackAxisRange + fZoom*[1,-1,1,-1];
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange= ...
           g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_aiFrontAxisRange+ fZoom*[1,-1,1,-1];

end
fnSetAxis();
return;


function fnScaleEllipseX(hAxes, afDiff)
global g_strctModule
[fDummy,iIndex] = max(abs(afDiff));
fZoom = afDiff(iIndex);
switch hAxes
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_fRadiusA = ...
        max(10,g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_fRadiusA  + fZoom);
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_fRadiusA = ...
        max(10,g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_fRadiusA  + fZoom);
end
fnInvalidate();
return;


function fnScaleEllipseY(hAxes, afDiff)
global g_strctModule
[fDummy,iIndex] = max(abs(afDiff));
fZoom = afDiff(iIndex);

switch hAxes
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_fRadiusB = ...
        max(10,g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_fRadiusB  + fZoom);
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_fRadiusB = ...
        max(10,g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_fRadiusB  + fZoom);
end
fnInvalidate();
return;


function fnMoveEllipse(hAxes, afDiff)
global g_strctModule
switch hAxes
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_pt2fCenter = ...
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_pt2fCenter+ afDiff;
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_pt2fCenter = ...
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_pt2fCenter  + afDiff;
end
fnInvalidate();
return;

function fnRotateEllipse(hAxes,afDiff)
global g_strctModule
switch hAxes
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_fOrientationDeg = ...
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctBackEllipse.m_fOrientationDeg+ afDiff(1);
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_fOrientationDeg = ...
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_strctFrontEllipse.m_fOrientationDeg+ afDiff(1);
end
fnInvalidate();
return;

function fnHandleMouseMoveWhileDown(strctPrevMouseOp, strctMouseOp)
global g_strctModule
afDelta= strctMouseOp.m_pt2fPos - strctPrevMouseOp.m_pt2fPos;
afDiff = g_strctModule.m_strctLastMouseDown.m_pt2fPos - strctMouseOp.m_pt2fPos;
    switch g_strctModule.m_strMouseMode
        case 'Pan'
            fnPanImage(strctMouseOp.m_hAxes,-afDelta/4);
        case 'Zoom'
            fnZoomImage(strctMouseOp.m_hAxes,-afDelta/4);
        case 'Move'
            fnMoveEllipse(strctMouseOp.m_hAxes,afDelta);
        case 'ScaleX'
            fnScaleEllipseX(strctMouseOp.m_hAxes,afDelta/4);
        case 'ScaleY'
            fnScaleEllipseY(strctMouseOp.m_hAxes,afDelta/4);
        case 'Rotate'
            fnRotateEllipse(strctMouseOp.m_hAxes,afDelta/20);
        case 'PanGrid'
            fnPanGridAux(strctMouseOp.m_hAxes,afDelta/20);
        case 'MoveHole'
            fnMoveHoleAux(strctMouseOp.m_hAxes,g_strctModule.m_iSelectedHoleOnDown,afDelta/40);
    end;
return;

function fnMoveHoleAux(hAxes,iSelectedHoleOnDown,afDelta)
global g_strctModule
switch hAxes
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
    
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleX(iSelectedHoleOnDown) = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleX(iSelectedHoleOnDown) + afDelta(1);
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleY(iSelectedHoleOnDown) = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleY(iSelectedHoleOnDown) + afDelta(2);
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleX(iSelectedHoleOnDown) = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleX(iSelectedHoleOnDown) + afDelta(1);
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleY(iSelectedHoleOnDown) = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleY(iSelectedHoleOnDown) + afDelta(2);
end
fnInvalidate();
return;


function fnPanGridAux(hAxes, afDelta)
global g_strctModule
switch hAxes
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
    
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleX = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleX + afDelta(1);
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleY = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afFrontHoleY + afDelta(2);
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleX = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleX + afDelta(1);
        g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleY = ...
            g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid}.m_afBackHoleY + afDelta(2);
end
fnInvalidate();
return;

        
function fnMouseMove(strctMouseOp)
global g_strctModule
if isempty(g_strctModule.m_strctPrevMouseOp)
    g_strctModule.m_strctPrevMouseOp = strctMouseOp;
end;

%%
if ~isempty( strctMouseOp.m_hAxes) && ~isempty(g_strctModule.m_iCurrGrid) && ~isempty(g_strctModule.m_acGrids)
                strctCurrGrid =  g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid};

    switch strctMouseOp.m_hAxes
        case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
            if ~isempty(strctCurrGrid.m_afFrontHoleX)
                aiSize = size(strctCurrGrid.m_a3fFrontImage);
                pt2fCenter = [(aiSize(2)-1)/2, (aiSize(1)-1)/2;];
                pt2fPosMM =  [strctMouseOp.m_pt2fPos(1) - pt2fCenter(1), ...
                    strctMouseOp.m_pt2fPos(2)-pt2fCenter(2) ] / strctCurrGrid.m_MM_To_Pix;
                iSelectedHole = find(sqrt((strctCurrGrid.m_afFrontHoleX-pt2fPosMM(1)).^2 + (strctCurrGrid.m_afFrontHoleY-pt2fPosMM(2)).^2) < (strctCurrGrid.m_fHoleDiameterMM/2));
                if ~isempty(iSelectedHole)
                    iSelectedHole=iSelectedHole(1)
                    afTheta = linspace(0,2*pi,20);
                    iNewResolution = size(strctCurrGrid.m_a3fFrontImage,1);
                    fDiameterMM = 2*strctCurrGrid.m_fRadiusMM;
                    fMM_To_Pix = iNewResolution/fDiameterMM;
                    afHolePixX = cos(afTheta) * strctCurrGrid.m_fHoleDiameterMM/2 * fMM_To_Pix;
                    afHolePixY = sin(afTheta) * strctCurrGrid.m_fHoleDiameterMM/2 * fMM_To_Pix;
                    afCoordX = afHolePixX + strctCurrGrid.m_afFrontHoleX(iSelectedHole) * fMM_To_Pix + ...
                        fDiameterMM/2 * fMM_To_Pix;
                    afCoordY = afHolePixY + strctCurrGrid.m_afFrontHoleY(iSelectedHole) * fMM_To_Pix + ...
                        fDiameterMM/2 * fMM_To_Pix;
                    
                    if isfield(g_strctModule,'m_hCurrHole') && ~isempty(g_strctModule.m_hCurrHole) && ishandle(g_strctModule.m_hCurrHole)
                        % set
                        set( g_strctModule.m_hCurrHole,'xdata',afCoordX,'ydata',afCoordY,'visible','on','color',[1 0 0]);
                    else
                        % create
                        g_strctModule.m_hCurrHole = plot(g_strctModule.m_strctPanel.m_strctFront.m_hAxes,...
                            afCoordX,afCoordY,'color',[1 0 0],'visible','on');
                    end;
                else
                    if isfield(g_strctModule,'m_hCurrHole') && ~isempty(g_strctModule.m_hCurrHole) && ishandle(g_strctModule.m_hCurrHole)
                        set( g_strctModule.m_hCurrHole,'visible','off');
                    end;
                end;
            end;
    end;
end;

%%

if  ~isempty(strctMouseOp.m_hAxes)
    if g_strctModule.m_bMouseDown
        fnHandleMouseMoveWhileDown(g_strctModule.m_strctPrevMouseOp, strctMouseOp);
    else
        fnUpdateStatusLine(strctMouseOp);
    end;
end;
g_strctModule.m_strctPrevMouseOp = strctMouseOp;
return;

function fnUpdateStatusLine(strctMouseOp)
global g_strctModule

return;

function fnZoomAxes(hAxes)
global g_strctModule
iMaxRectSize =  min(g_strctModule.m_strctPanel.m_aiWindowsPanelSize(3:4))-30;
aiZoomPos = [g_strctModule.m_strctPanel.m_aiWindowsPanelSize(1:2), iMaxRectSize,iMaxRectSize];

switch hAxes
    case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
       aiCurrPosition = get(g_strctModule.m_strctPanel.m_strctBack.m_hPanel,'Position');
        if  all(g_strctModule.m_strctPanel.m_strctBack.m_aiPos-aiCurrPosition == 0)
            % Zoom in
            set(g_strctModule.m_strctPanel.m_strctBack.m_hPanel,'Position',aiZoomPos,'visible','on');
            set(g_strctModule.m_strctPanel.m_strctBack.m_hAxes,'Position',aiZoomPos);
            set(g_strctModule.m_strctPanel.m_strctFront.m_hPanel,'visible','off');
        else
            % Zoom out
             set(g_strctModule.m_strctPanel.m_strctBack.m_hPanel,'Position',g_strctModule.m_strctPanel.m_strctBack.m_aiPos,'visible','on');
            set(g_strctModule.m_strctPanel.m_strctBack.m_hAxes,'Position',g_strctModule.m_strctPanel.m_aiAxesSize);
            set(g_strctModule.m_strctPanel.m_strctFront.m_hPanel,'visible','on');
        end;
        
    case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
        aiCurrPosition = get(g_strctModule.m_strctPanel.m_strctFront.m_hPanel,'Position');
        if  all(g_strctModule.m_strctPanel.m_strctFront.m_aiPos-aiCurrPosition == 0)
            % Zoom in
            set(g_strctModule.m_strctPanel.m_strctFront.m_hPanel,'Position',aiZoomPos,'visible','on');
            set(g_strctModule.m_strctPanel.m_strctFront.m_hAxes,'Position',aiZoomPos);
            set(g_strctModule.m_strctPanel.m_strctBack.m_hPanel,'visible','off');
        else
            % Zoom out
            set(g_strctModule.m_strctPanel.m_strctFront.m_hPanel,'Position',g_strctModule.m_strctPanel.m_strctFront.m_aiPos,'visible','on');
            set(g_strctModule.m_strctPanel.m_strctFront.m_hAxes,'Position',g_strctModule.m_strctPanel.m_aiAxesSize);
            set(g_strctModule.m_strctPanel.m_strctBack.m_hPanel,'visible','on');
        end;

end;
return;

function iSelectedHole = fnGetSelectedHole(strctMouseOp)
global g_strctModule
iSelectedHole = [];

if ~isempty( strctMouseOp.m_hAxes) && ~isempty(g_strctModule.m_iCurrGrid) && ~isempty(g_strctModule.m_acGrids)
    strctCurrGrid =  g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid};
    switch strctMouseOp.m_hAxes
        case g_strctModule.m_strctPanel.m_strctFront.m_hAxes
            if ~isempty(strctCurrGrid.m_afFrontHoleX)
                aiSize = size(strctCurrGrid.m_a3fFrontImage);
                pt2fCenter = [(aiSize(2)-1)/2, (aiSize(1)-1)/2;];
                pt2fPosMM =  [strctMouseOp.m_pt2fPos(1) - pt2fCenter(1), ...
                    strctMouseOp.m_pt2fPos(2)-pt2fCenter(2) ] / strctCurrGrid.m_MM_To_Pix;
                iSelectedHole = find(sqrt((strctCurrGrid.m_afFrontHoleX-pt2fPosMM(1)).^2 + (strctCurrGrid.m_afFrontHoleY-pt2fPosMM(2)).^2) < (strctCurrGrid.m_fHoleDiameterMM/2));
            end;
        case g_strctModule.m_strctPanel.m_strctBack.m_hAxes
            if ~isempty(strctCurrGrid.m_afBackHoleX)
                aiSize = size(strctCurrGrid.m_a3fBackImage);
                pt2fCenter = [(aiSize(2)-1)/2, (aiSize(1)-1)/2;];
                pt2fPosMM =  [strctMouseOp.m_pt2fPos(1) - pt2fCenter(1), ...
                    strctMouseOp.m_pt2fPos(2)-pt2fCenter(2) ] / strctCurrGrid.m_MM_To_Pix;
                iSelectedHole = find(sqrt((strctCurrGrid.m_afBackHoleX-pt2fPosMM(1)).^2 + ...
                    (strctCurrGrid.m_afBackHoleY-pt2fPosMM(2)).^2) < (strctCurrGrid.m_fHoleDiameterMM/2));
            end;
            
    end;
    
    
    
end;

return;



function fnMouseDown(strctMouseOp)
global g_strctModule

if strcmpi(strctMouseOp.m_strButton,'DoubleClick') && ~isempty(strctMouseOp.m_hAxes)
    fnZoomAxes(strctMouseOp.m_hAxes);
    return;
end;
% 
% if strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strctGrid.m_hAxes
%     
%     fnSelectGridHole(strctMouseOp);
%     fnHandleMouseMoveOnGridAxes(strctMouseOp);
% end;

g_strctModule.m_iSelectedHoleOnDown = fnGetSelectedHole(strctMouseOp);

g_strctModule.m_strctLastMouseDown = strctMouseOp;
g_strctModule.m_bMouseDown = true;
% fnSetRes(64);

return;
       

function fnMouseUp(strctMouseOp)
global g_strctModule
g_strctModule.m_strctLastMouseUp = strctMouseOp;
g_strctModule.m_bMouseDown = false;
% fnSetRes(256);
return;

function [ahHandles] = fnDrawEllipse(hAxes,strctEllipse,iQuant)
afTheta= linspace(0,2*pi,iQuant);
a2fR = [cos(strctEllipse.m_fOrientationDeg/180*pi), sin(strctEllipse.m_fOrientationDeg/180*pi);
        -sin(strctEllipse.m_fOrientationDeg/180*pi) cos(strctEllipse.m_fOrientationDeg/180*pi)];
Tmp = a2fR * [strctEllipse.m_fRadiusA*cos(afTheta);strctEllipse.m_fRadiusB*sin(afTheta)];
afX = Tmp(1,:) + strctEllipse.m_pt2fCenter(1);
afY = Tmp(2,:) + strctEllipse.m_pt2fCenter(2);
ahHandles(1) = plot(hAxes,afX,afY,'b','linewidth',2);


Tmp = a2fR * [-strctEllipse.m_fRadiusA, strctEllipse.m_fRadiusA,0,0,0;
              0,0,0,-strctEllipse.m_fRadiusB,strctEllipse.m_fRadiusB];
afX = Tmp(1,:) + strctEllipse.m_pt2fCenter(1);
afY = Tmp(2,:) + strctEllipse.m_pt2fCenter(2);
ahHandles(2) = plot(hAxes,afX(1:2),afY(1:2),'b','linewidth',1);
ahHandles(3) = plot(hAxes,afX(3:4),afY(3:4),'g','linewidth',1);
ahHandles(4) = plot(hAxes,afX([3,5]),afY([3,5]),'b','linewidth',1);

return;

function ahHoleHandles = fnDrawFrontHoles(hAxes,strctCurrGrid)

afTheta = linspace(0,2*pi,20);
iNewResolution = size(strctCurrGrid.m_a3fFrontImage,1);
fDiameterMM = 2*strctCurrGrid.m_fRadiusMM;
fMM_To_Pix = iNewResolution/fDiameterMM;
afHolePixX = cos(afTheta) * strctCurrGrid.m_fHoleDiameterMM/2 * fMM_To_Pix;
afHolePixY = sin(afTheta) * strctCurrGrid.m_fHoleDiameterMM/2 * fMM_To_Pix;
ahHoleHandles = zeros(1,length(strctCurrGrid.m_afFrontHoleX));
for k=1:length(strctCurrGrid.m_afFrontHoleX)
    ahHoleHandles(k) = plot(hAxes,...
        afHolePixX + strctCurrGrid.m_afFrontHoleX(k) * fMM_To_Pix + ...
        fDiameterMM/2 * fMM_To_Pix,...
        afHolePixY + strctCurrGrid.m_afFrontHoleY(k) * fMM_To_Pix + ...
        fDiameterMM/2 * fMM_To_Pix,'color',[0 0.5 0]);
end;
return;


function fnFirstInvalidate()
global g_strctModule
g_strctModule.m_bFirstInvalidate = false;

 return;
 
function fnInvalidate(bRedrawImages)
global g_strctModule
if ~exist('bRedrawImages','var')
    bRedrawImages = false;
end;

if g_strctModule.m_iCurrGrid == 0
    % Black out screens
    return;
end;

strctCurrGrid = g_strctModule.m_acGrids{g_strctModule.m_iCurrGrid};

delete(g_strctModule.m_strctPanel.m_ahDrawHandles(ishandle(g_strctModule.m_strctPanel.m_ahDrawHandles)));

ahFrontHandles = fnDrawEllipse(g_strctModule.m_strctPanel.m_strctFront.m_hAxes, strctCurrGrid.m_strctFrontEllipse,100);
ahBackHandles = fnDrawEllipse(g_strctModule.m_strctPanel.m_strctBack.m_hAxes, strctCurrGrid.m_strctBackEllipse,100);
ahHoleHandles = fnDrawFrontHoles(g_strctModule.m_strctPanel.m_strctFront.m_hAxes,strctCurrGrid);

g_strctModule.m_strctPanel.m_ahDrawHandles = [ahFrontHandles,ahBackHandles,ahHoleHandles];

if bRedrawImages
    set(g_strctModule.m_strctPanel.m_strctFront.m_hImage,'cdata',strctCurrGrid.m_a3fFrontImage);
    set(g_strctModule.m_strctPanel.m_strctBack.m_hImage,'cdata',strctCurrGrid.m_a3fBackImage);
end


return

function Y=fnDup3(X)
Y=reshape([X,X,X], [size(X),3]);
%Y(:,:,1) = X;
%Y(:,:,2) = X;
%Y(:,:,3) = X;
return;
