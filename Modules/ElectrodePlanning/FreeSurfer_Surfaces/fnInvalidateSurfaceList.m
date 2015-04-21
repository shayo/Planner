function fnInvalidateSurfaceList()
global g_strctModule
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_acFreeSurferSurfaces')
    set(g_strctModule.m_strctPanel.m_hSurfaceList,'string','');
else
    iNumSurfaces = length(   g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces);
    acSurfaceNames= cell(1,iNumSurfaces);
    for k=1:iNumSurfaces
        acSurfaceNames{k} =  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{k}.m_strName;
    end;
    if length(acSurfaceNames) >= 1
        set(g_strctModule.m_strctPanel.m_hSurfaceList,'string',acSurfaceNames,'value',1);
    else
        set(g_strctModule.m_strctPanel.m_hSurfaceList,'string',acSurfaceNames,'value',0);
    end
end

    
%fnInvalidateDerivedSurfaceList();

return;


