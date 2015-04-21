function fnSetNewAtlas()
global g_strctModule
iSelectedAtlas = get(g_strctModule.m_strctPanel.m_hAtlasList,'value');
acAtlasOpt = get(g_strctModule.m_strctPanel.m_hAtlasList,'string');
if strcmp(acAtlasOpt{iSelectedAtlas},'Load...')
    % load new atlas file...
    [strFile,strPath]=uigetfile('*.mat');
    if strFile(1) ==0
        return;
    end;
    
   strctTmp = load(fullfile(strPath,strFile));
   if ~isfield(strctTmp,'strctAtlas')
       return;
   end;
    strctAtlas = strctTmp.strctAtlas;
    for k=1:length(strctAtlas.m_astrctMesh)
        strctAtlas.m_astrctMesh(k).visible = false;
    end
    g_strctModule.m_strctAtlas = strctAtlas;
    set(g_strctModule.m_strctPanel.m_hAtlasList,'string',{strFile,'Load...'},'value',1);
    
    fnUpdateAtlasTable();
    fnInvalidate(1);
    
else
    % assume this was already loaded?
    
    fnUpdateAtlasTable();
    fnInvalidate(1);
    
end