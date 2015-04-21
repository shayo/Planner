function fnSetFixedZoom(varargin)
global g_strctModule
if isempty(varargin{1})
    switch g_strctModule.m_strctMouseOpMenu.m_hAxes
        case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
            fCurrentZoom = g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM;
        case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
            fCurrentZoom = g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM;
        case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
            fCurrentZoom = g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM;
        otherwise
            fCurrentZoom = 50;
    end
    
    
    prompt={'Enter scale in mm:'};
    name='Scale';
    numlines=1;
    defaultanswer={num2str(fCurrentZoom)};
    
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    fScaleMM = str2num(answer{1});
else
    fScaleMM = varargin{1};
end

switch g_strctModule.m_strctMouseOpMenu.m_hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM = fScaleMM;
        g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM =fScaleMM;
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM = fScaleMM;
        g_strctModule.m_strctCrossSectionYZ.m_fHalfWidthMM =fScaleMM;
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM = fScaleMM;
        g_strctModule.m_strctCrossSectionXZ.m_fHalfWidthMM =fScaleMM;
end
fnInvalidate(1);