function varargout = PlannerAPI(strCommand, varargin)
global g_strctModule
switch strCommand
    case 'StartPlanner'
        EntryPoint();
    case 'GetCrossHairIntersectionPoint'
        % No inputs
        % Outputs: 1x3, [x=ML, y=DV   ,z=AP]
        [pt3iPointOnLine, afLineDir] = fnPlanePlaneIntersection(g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionYZ);
        pt3fIntersectionPoint = fnPlaneLineIntersection(g_strctModule.m_strctCrossSectionXZ, pt3iPointOnLine, afLineDir);
        varargout{1} = pt3fIntersectionPoint;
    case 'GetFuncXYZ_To_IJK'
        
        SelectedFunctional = varargin{1};
        if isnumeric(SelectedFunctional)
            iSelectedFunctional= SelectedFunctional;
            fprintf('Selecting %s\n',g_strctModule.m_acFuncVol{SelectedFunctional}.m_strName);
        else
            acVolumeName = cell(1,length(g_strctModule.m_acFuncVol));
            for k=1:length(g_strctModule.m_acFuncVol)
                acVolumeName{k} = g_strctModule.m_acFuncVol{k}.m_strName;
            end
            iSelectedFunctional= find(ismember(acVolumeName,SelectedFunctional));
        end
        
        
        a2fCRS_To_XYZ_Func = g_strctModule.m_acFuncVol{iSelectedFunctional}.m_a2fReg*g_strctModule.m_acFuncVol{iSelectedFunctional}.m_a2fM;        
         varargout{1} = inv(  a2fCRS_To_XYZ_Func);
         
    case 'GetROI_Volume_By_Index'
         iAnatomicalVolumeIndex = varargin{1};
        iROIIndex = varargin{2};
        a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{iAnatomicalVolumeIndex}.m_a2fReg*g_strctModule.m_acAnatVol{iAnatomicalVolumeIndex}.m_a2fM;
        
        a3bTemp = zeros(size(g_strctModule.m_acAnatVol{iAnatomicalVolumeIndex}.m_a3fVol),'uint8')>0;
        a3bTemp(g_strctModule.m_acAnatVol{iAnatomicalVolumeIndex}.m_astrctROIs(iROIIndex).m_aiVolumeIndices)=true;
        varargout{1} = a3bTemp;
        varargout{2} =a2fCRS_To_XYZ;

    case 'GetROI_Func_Coordinates_By_Name'
        
        iAnatomicalVolumeIndex = varargin{1};
        strROI = varargin{2};
        iSelectedFunctional = varargin{3};
        iROIIndex = find(ismember({g_strctModule.m_acAnatVol{iAnatomicalVolumeIndex}.m_astrctROIs.m_strName},strROI));
        if ~isempty(iROIIndex)
          varargout{1} =  PlannerAPI('GetROI_Func_Coordinates_By_Index',iAnatomicalVolumeIndex,iROIIndex,iSelectedFunctional);
        end
        
    case 'GetROI_Func_Coordinates_By_Index'
        
        iAnatomicalVolumeIndex = varargin{1};
        iROIIndex = varargin{2};
        iSelectedFunctional = varargin{3};

        [aiI,aiJ,aiK]=ind2sub( size(g_strctModule.m_acAnatVol{iAnatomicalVolumeIndex}.m_a3fVol),         g_strctModule.m_acAnatVol{iAnatomicalVolumeIndex}.m_astrctROIs(iROIIndex).m_aiVolumeIndices);
        P = [aiJ;aiI;aiK];
        iNumPoints =size(aiI,2);
        PAug = [P; ones(1,iNumPoints)];
        % Transform points to target coordinate system. First to MM
        
        a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{iAnatomicalVolumeIndex}.m_a2fReg*g_strctModule.m_acAnatVol{iAnatomicalVolumeIndex}.m_a2fM;
        a2fCRS_To_XYZ_Func = g_strctModule.m_acFuncVol{iSelectedFunctional}.m_a2fReg*g_strctModule.m_acFuncVol{iSelectedFunctional}.m_a2fM;        
        Tmp = inv(a2fCRS_To_XYZ_Func )*a2fCRS_To_XYZ *PAug;
        varargout{1} = Tmp(1:3,:);
    case 'LoadSession'
        strSessionName = varargin{1};
        if ~exist(strSessionName,'file')
            varargout{1} = [];
            return;
        else
            fnLoadSessionAux(strSessionName);
             varargout{1} = 1;
        end;
    case 'GetFuncVol'
        SelectedFunctional = varargin{1};
        if isnumeric(SelectedFunctional)
            iSelectedFunctional= SelectedFunctional;
        else
            acVolumeName = cell(1,length(g_strctModule.m_acFuncVol));
            for k=1:length(g_strctModule.m_acFuncVol)
                acVolumeName{k} = g_strctModule.m_acFuncVol{k}.m_strName;
            end
            iSelectedFunctional= find(ismember(acVolumeName,SelectedFunctional));
        end
       
        varargout{1} =  g_strctModule.m_acFuncVol{iSelectedFunctional}.m_a3fVol;
    case 'GetGridHolesDirectionsMM'
        iSelectedAnatomical = varargin{1};
        iSelectedChamber = varargin{2};
        iSelectedGrid = varargin{3};
        strctGrid = g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_astrctChambers(iSelectedChamber).m_astrctGrids(iSelectedGrid);
        aiSelectedHoles = find(strctGrid.m_strctModel.m_strctGridParams.m_abSelectedHoles);
        P0 = [-strctGrid.m_strctModel.m_afGridHolesX(aiSelectedHoles);strctGrid.m_strctModel.m_afGridHolesY(aiSelectedHoles);ones(1,length(aiSelectedHoles))];
        P1 = P0 + strctGrid.m_strctModel.m_apt3fGridHolesNormals(:,aiSelectedHoles);
        % Now we know the direction in the grid coordiante system.
        % Transform it to chamber and then to MM space....
        strctChamber = g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_astrctChambers(iSelectedChamber);
        a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_a2fReg*g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_a2fM; 
        a2fM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;
       a2fGridOffsetTransform = eye(4);
       a2fGridOffsetTransform(3,4) = -strctGrid.m_fChamberDepthOffset;
       a2fM_WithMeshOffset =a2fM*a2fGridOffsetTransform;
       P0mm=a2fM_WithMeshOffset*[P0; ones(1,size(P0,2))];
       P1mm=a2fM_WithMeshOffset*[P1; ones(1,size(P1,2))];
       varargout{1} = P0mm(1:3,:);
       varargout{2} =  P1mm(1:3,:)-P0mm(1:3,:);
    case 'RenderCrossSection'
       iSelectedAnatomical = varargin{1};
       SelectedFunctional = varargin{2};
       if ~isempty(SelectedFunctional)
           if isnumeric(SelectedFunctional)
               iSelectedFunctional = SelectedFunctional;
           else
               acVolumeName = cell(1,length(g_strctModule.m_acFuncVol));
               for k=1:length(g_strctModule.m_acFuncVol)
                   acVolumeName{k} = g_strctModule.m_acFuncVol{k}.m_strName;
               end
               iSelectedFunctional= find(ismember(acVolumeName,SelectedFunctional));
               
           end
       else
           iSelectedFunctional = [];
       end
       
       a2fM =  varargin{3};
       fHalfWidthMM =  varargin{4};
       
       if length(varargin) >= 5
            strctOverlay.m_pt2fLeft  = [varargin{5}(1) 1];
            strctOverlay.m_pt2fRight  = [varargin{5}(2) 0];
            strctOverlay.m_pt2fLeftPos  = [varargin{5}(3) 0];
            strctOverlay.m_pt2fRightPos  = [varargin{5}(4) 1];
       else
            strctOverlay = g_strctModule.m_strctOverlay;
       end;
       
       strctCrossSection.m_a2fM = a2fM;
       strctCrossSection.m_fHalfWidthMM = fHalfWidthMM;
       strctCrossSection.m_fHalfHeightMM = fHalfWidthMM;
       strctCrossSection.m_iResWidth = 512;
       strctCrossSection.m_iResHeight = 512;
        a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_a2fReg*g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_a2fM;
       
       a2fXYZ_To_CRS = inv(a2fCRS_To_XYZ );
       [a2fCrossSection, apt3fPlanePoints,a2fXmm,a2fYmm,a2fXmmT,a2fYmmT,a2fZmmT,apt3fInVolMM] = fnResampleCrossSection(g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_a3fVol, ...
           a2fXYZ_To_CRS, strctCrossSection);
        a2fCrossSectionGray = fnContrastTransform(a2fCrossSection, g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_strctContrastTransform);
        if ~isempty(iSelectedFunctional)
            a2fXYZ_To_CRS_Func = inv(g_strctModule.m_acFuncVol{iSelectedFunctional}.m_a2fM) * inv(g_strctModule.m_acFuncVol{iSelectedFunctional}.m_a2fReg); %#ok
            Pcrs_func = a2fXYZ_To_CRS_Func * apt3fInVolMM;
           a2fCrossSection_Func = reshape(fndllFastInterp3(g_strctModule.m_acFuncVol{iSelectedFunctional}.m_a3fVol, 1+Pcrs_func(1,:),1+Pcrs_func(2,:),1+Pcrs_func(3,:)), size(a2fCrossSection));
           
            [a3fCross_Func, a2fCross_Alpha] = fnOverlayTransformAux(a2fCrossSection_Func, strctOverlay);
            a3fCrossSectionFinal= ((1-fnDup3(a2fCross_Alpha)) .* fnDup3(a2fCrossSectionGray)) + fnDup3(a2fCross_Alpha) .* a3fCross_Func;
        else
            a3fCrossSectionFinal = fnDup3(a2fCrossSectionGray);
        end
        
        
        if ~isempty(g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_acFreeSurferSurfaces) 
                iNumSurfaces = length(g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_acFreeSurferSurfaces);
                iGlobalCounter = 1;
                for iSurfaceIter=1:iNumSurfaces
                    a2fLines = fnMeshCrossSectionIntersection(g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_acFreeSurferSurfaces{iSurfaceIter}, strctCrossSection);;
                    if ~isempty(a2fLines)
                      astrctSurfaceLines(iGlobalCounter).m_a2fLines = a2fLines;
                      astrctSurfaceLines(iGlobalCounter).m_afColor = g_strctModule.m_acAnatVol{iSelectedAnatomical}.m_acFreeSurferSurfaces{iSurfaceIter}.m_afColor; 
                      iGlobalCounter = iGlobalCounter + 1;
                    end
                end
        else 
            astrctSurfaceLines = [];
        end
                    
         varargout{1} = a3fCrossSectionFinal;
         varargout{2} = astrctSurfaceLines;
         varargout{3} = strctCrossSection;
         varargout{4} = a2fXmm;
         varargout{5} = a2fYmm;
         
    case 'GetCrossSectionMatrix'
        strCrossSection = varargin{1};
        switch lower(strCrossSection)
            case 'coronal'
            a2fM = g_strctModule.m_strctCrossSectionXZ.m_a2fM;
                fRangeMM = g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM;
            case 'horizontal'
            a2fM = g_strctModule.m_strctCrossSectionXY.m_a2fM;
                fRangeMM = g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM;
            case 'saggital'
                     
                 a2fM = g_strctModule.m_strctCrossSectionYZ.m_a2fM;
                fRangeMM = g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM;
        end
          varargout{1} = a2fM;
            varargout{2}  = fRangeMM;
    otherwise
        fprintf('Unknown command\n');
end
return;
