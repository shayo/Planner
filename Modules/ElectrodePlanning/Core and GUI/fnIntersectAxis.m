
function [hAxes,bCloseToCenter, afPenDir,hAxesLine] = fnIntersectAxis(strctMouseOp)
global g_strctModule g_strctWindows
hAxes = [];
hAxesLine = [];
fThreshold = 2;
iWindowSize = g_strctModule.m_strctPanel.m_strctXY.m_aiPos(end);
fCenterDist = 0.6*(iWindowSize/2); %#ok
bCloseToCenter = false; %#ok
afPenDir = [];
bCloseToCenter = min([abs(255-strctMouseOp.m_pt2fPos(2)),abs(255-strctMouseOp.m_pt2fPos(1)),(strctMouseOp.m_pt2fPos(2)),(strctMouseOp.m_pt2fPos(1))]) > 20;
if ~isempty(strctMouseOp.m_hAxes)
    switch strctMouseOp.m_hAxes
        case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
            [fDistXZ, fDistFromCenterXZ,afPenDirXZ] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ); %#ok
            [fDistYZ, fDistFromCenterYZ,afPenDirYZ] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ); %#ok
            %[fDistXZ, fDistFromCenterXZ;fDistYZ, fDistFromCenterYZ]
            if fDistXZ < fDistYZ
                if fDistXZ < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctXZ.m_hAxes;
                    %bCloseToCenter = fDistFromCenterXZ < fCenterDist;
                    afPenDir = afPenDirXZ;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ;
                end;
            else
                if fDistYZ < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctYZ.m_hAxes;
                    %bCloseToCenter = fDistFromCenterYZ < fCenterDist;
                    afPenDir = afPenDirYZ;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ;
                end;
            end;
         case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
            [fDistXZ, fDistFromCenterXZ,afPenDirXZ] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ);  %#ok
            [fDistXY, fDistFromCenterXY,afPenDirXY] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY); %#ok
            if fDistXZ < fDistXY
                if fDistXZ < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctXZ.m_hAxes;
                    %bCloseToCenter = fDistFromCenterXZ < fCenterDist;
                    afPenDir = afPenDirXZ;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ;
                end;
            else
                if fDistXY < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctXY.m_hAxes;
                    %bCloseToCenter = fDistFromCenterXY < fCenterDist;
                    afPenDir = afPenDirXY;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY;
                end;
            end;
        case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
            [fDistYZ, fDistFromCenterYZ,afPenDirYZ] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ); %#ok
            [fDistXY, fDistFromCenterXY,afPenDirXY] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY); %#ok
            if fDistYZ < fDistXY
                if fDistYZ < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctYZ.m_hAxes;
                    %bCloseToCenter = fDistFromCenterYZ < fCenterDist;
                    afPenDir = -afPenDirYZ;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ;
                end;
            else
                if fDistXY < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctXY.m_hAxes;
                   % bCloseToCenter = fDistFromCenterXY < fCenterDist;
                    afPenDir = -afPenDirXY;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY;
                end;
            end;            
    end;
end;

if ~isempty(hAxes)
    if bCloseToCenter
       strPrev = get(g_strctWindows.m_hFigure,'Pointer');
       g_strctModule.m_strPrevMouseIcon = strPrev;
       set(g_strctWindows.m_hFigure,'Pointer','fleur');
    else
        strPrev = get(g_strctWindows.m_hFigure,'Pointer');
        g_strctModule.m_strPrevMouseIcon = strPrev;
        set(g_strctWindows.m_hFigure,'Pointer','topl');
    end;
else
    if isfield(g_strctModule,'m_strPrevMouseIcon') && ~isempty(g_strctModule.m_strPrevMouseIcon)
        set(g_strctWindows.m_hFigure,'Pointer',g_strctModule.m_strPrevMouseIcon);
        g_strctModule.m_strPrevMouseIcon = [];
    else
        set(g_strctWindows.m_hFigure,'Pointer','arrow');
        g_strctModule.m_strPrevMouseIcon = 'arrow';
    end
end;
%topl - diagonal

%       rosshair | {arrow} | watch | topl | 
%topr | botl | botr | circle | cross | 
%fleur | left | right | top | bottom | 
%fullcrosshair | ibeam | custom | hand

return;