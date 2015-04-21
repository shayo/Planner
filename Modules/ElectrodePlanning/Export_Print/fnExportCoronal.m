function fnExportCoronal()
global g_strctModule
    
strFolderName = uigetdir('.','Where to export images?');
if strFolderName(1) == 0
    return;
end;
  
% Resample coronal atlas slice from volume...
afMLrange = g_strctModule.m_strctAtlas.m_afXPixelToMM;
afDVrange = g_strctModule.m_strctAtlas.m_afYPixelToMM;
afAPRange = -25:50;
 h = waitbar(0,'Generating atlas...');
for iIter=1:length(afAPRange)
     waitbar(iIter/length(afAPRange),h);
% Image coordinates.
[a2fX,a2fY]=meshgrid(afMLrange,afDVrange);
a2fZ = ones( size(a2fX)) * afAPRange(iIter); % AP 0
% Convert from atlas coords to 3D mm coordinates
P = [a2fX(:),a2fY(:),a2fZ(:), ones(length(a2fX(:)),1)];
Pmm = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg * P';
% Convert to CRS
a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg); %#ok
Pcrs = a2fXYZ_To_CRS * Pmm;
a2fCrossSection = reshape(fndllFastInterp3(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol, 1+Pcrs(1,:),1+Pcrs(2,:),1+Pcrs(3,:)), size(a2fX));
a2fCrossSectionGray = fnContrastTransform(a2fCrossSection, g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctContrastTransform);
% While we are at it, lets sample the functional volume as well....

if ~isempty(g_strctModule.m_acFuncVol)
    a2fXYZ_To_CRS_Func = inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fM) * inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg); %#ok
    Pcrs_func = a2fXYZ_To_CRS_Func * Pmm;
    a2fCrossSection_Func = reshape(fndllFastInterp3(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol, 1+Pcrs_func(1,:),1+Pcrs_func(2,:),1+Pcrs_func(3,:)), size(a2fX));
    [a3fCross_Func, a2fCross_Alpha] = fnOverlayContrastTransform(a2fCrossSection_Func);
    
    a3fCrossSectionFinal= ((1-fnDup3(a2fCross_Alpha)) .* fnDup3(a2fCrossSectionGray)) + fnDup3(a2fCross_Alpha) .* a3fCross_Func;
else
    a3fCrossSectionFinal=fnDup3(a2fCrossSectionGray);
end
strOutFile = fullfile(strFolderName,sprintf('coronal%d_rect.jpg',round(afAPRange(iIter))));
imwrite(a3fCrossSectionFinal,strOutFile);
end
delete(h);    
return;