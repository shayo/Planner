
function iNewIndex = fnAddGridFromStruct(strctGrid, iSubModelIndex)
global g_strctModule

% Build the model
strctGridParams = feval(strctGrid.m_strctGeneral.m_strDefine);
% Apply sub model adjustments
if ~isempty(iSubModelIndex)
    acFieldNames = setdiff(fieldnames(strctGrid.m_acSubModels{iSubModelIndex}),'m_strName');
    for iFieldIter=1:length(acFieldNames)
        strFieldName = acFieldNames{iFieldIter}(6:end);
        strctGridParams = fnSetGridParameter(strctGridParams, strFieldName, getfield(strctGrid.m_acSubModels{iSubModelIndex},acFieldNames{iFieldIter})  ); %#ok
    end
end
strctGrid.m_strctModel =  feval(strctGrid.m_strctGeneral.m_strBuildModel, strctGridParams);
strctGrid.m_fChamberDepthOffset = 0;
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids)
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids = strctGrid;
    iNewIndex = 1;
else
    iNewIndex = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids)+1;
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iNewIndex) = strctGrid;
end;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected = ...
    length( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids);
fnUpdateGridList();
fnUpdateGridAxes(false);

return;


