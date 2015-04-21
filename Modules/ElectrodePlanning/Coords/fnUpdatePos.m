function fnUpdatePos()
global g_strctModule
strctMouseOp = g_strctModule.m_strctPrevMouseOp;
[pt3fPosIn3DSpace,pt3fPosInStereoSpace, pt3fVoxelCoordinate, strctCrossSection,pt3fPosInAtlasSpace]=fnGet3DCoord(strctMouseOp); %#ok

if ~isempty(g_strctModule.m_acAnatVol)
    if isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctChambers')
        if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
            
            a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg); %#ok

            a2fChamberXYZ = inv(a2fXYZ_To_CRS) * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
            angleXY = acos(min(1,max(-1,dot(a2fChamberXYZ(1:3,3), -g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,3)))))/pi*180;
            angleXZ = acos(min(1,max(-1,dot(a2fChamberXYZ(1:3,3), g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3)))))/pi*180;
            angleYZ = acos(min(1,max(-1,dot(a2fChamberXYZ(1:3,3), g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,3)))))/pi*180;
            
            set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(12),'String', ...
                sprintf('Chamber Angles: XY: %.2f, XZ: %.2f, YZ: %.2f',angleXY,angleXZ,angleYZ));
        end
    end
end
    
if ~isempty(strctMouseOp.m_pt2fPos)
    %set(g_strctModule.m_strctPanel.m_hStatusLine,'string',sprintf('Mouse at [%.0f %.0f] in %.5f',...
    %    strctMouseOp.m_pt2fPos(1),strctMouseOp.m_pt2fPos(2), strctMouseOp.m_hAxes));

% set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(5),'String', sprintf('AP %.2f (%.2f), C=%.2f, X=%.2f',-pt3fPosInStereoSpace(1),pt3fPosInAtlasSpace(1),pt3fVoxelCoordinate(1),pt3fPosIn3DSpace(1)));
% set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(6),'String', sprintf('ML %.2f (%.2f), R=%.2f, Y=%.2f',-pt3fPosInStereoSpace(2),pt3fPosInAtlasSpace(2),pt3fVoxelCoordinate(2),pt3fPosIn3DSpace(2)));
% set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(7),'String', sprintf('DV %.2f (%.2f), S=%.2f, Z=%.2f',-pt3fPosInStereoSpace(3),pt3fPosInAtlasSpace(3),pt3fVoxelCoordinate(3),pt3fPosIn3DSpace(3)));

set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(5),'String', sprintf('AP %.2f (%.2f)',-pt3fPosInStereoSpace(1),pt3fPosInAtlasSpace(1)));
set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(6),'String', sprintf('ML %.2f (%.2f)',pt3fPosInStereoSpace(2),pt3fPosInAtlasSpace(2)));
set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(7),'String', sprintf('DV %.2f (%.2f)',pt3fPosInStereoSpace(3),pt3fPosInAtlasSpace(3)));

    if 1% strcmpi(g_strctModule.m_strMouseMode,'QueryAtlas')
         % Round to nearest AP slice ?
         if ~isempty(g_strctModule.m_strctAtlas.m_astrctSlices)
             
         [fDummy,iIndex]=min(abs(cat(1,g_strctModule.m_strctAtlas.m_astrctSlices.m_fPositionMM) - pt3fPosInAtlasSpace(1)));
         if fDummy > 2
             % Too far away from any known slice....
             strAtlasRegion = 'Unknown';
         else
            iNumRegionsToTest = length(g_strctModule.m_strctAtlas.m_astrctSlices(iIndex).m_acRegions);
            strAtlasRegion = 'Unknown';
            
              for iRegionIter=1:iNumRegionsToTest
                 % Convert pixels to mm (stupid). Should have been done
                 % before...
                 if ~isempty(g_strctModule.m_strctAtlas.m_astrctSlices(iIndex).m_acRegions{iRegionIter}.m_apt2fCoordinates)
                  afRegionXinMM= (g_strctModule.m_strctAtlas.m_astrctSlices(iIndex).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,1)-1) *(g_strctModule.m_strctAtlas.m_afXPixelToMM(2)-g_strctModule.m_strctAtlas.m_afXPixelToMM(1)) + g_strctModule.m_strctAtlas.m_afXPixelToMM(1);
                  afRegionYinMM= (g_strctModule.m_strctAtlas.m_astrctSlices(iIndex).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,2)-1) *(g_strctModule.m_strctAtlas.m_afYPixelToMM(2)-g_strctModule.m_strctAtlas.m_afYPixelToMM(1)) + g_strctModule.m_strctAtlas.m_afYPixelToMM(1);
                 bInsideRegion = inpolygon(pt3fPosInAtlasSpace(2),pt3fPosInAtlasSpace(3), afRegionXinMM,afRegionYinMM);

                  afRegionXinMM= -((g_strctModule.m_strctAtlas.m_astrctSlices(iIndex).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,1)-1) *(g_strctModule.m_strctAtlas.m_afXPixelToMM(2)-g_strctModule.m_strctAtlas.m_afXPixelToMM(1)) + g_strctModule.m_strctAtlas.m_afXPixelToMM(1));
                  afRegionYinMM= (g_strctModule.m_strctAtlas.m_astrctSlices(iIndex).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,2)-1) *(g_strctModule.m_strctAtlas.m_afYPixelToMM(2)-g_strctModule.m_strctAtlas.m_afYPixelToMM(1)) + g_strctModule.m_strctAtlas.m_afYPixelToMM(1);
                 bInsideRegion2 = inpolygon(pt3fPosInAtlasSpace(2),pt3fPosInAtlasSpace(3), afRegionXinMM,afRegionYinMM);
                 
                 if bInsideRegion || bInsideRegion2
                     strAtlasRegion = g_strctModule.m_strctAtlas.m_astrctSlices(iIndex).m_acRegions{iRegionIter}.m_strName;
                 end
                 end
             end
         end
          set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(11),'string',sprintf('Atlas Region: %s ',strAtlasRegion));
         end
         
    end
end;
return;
