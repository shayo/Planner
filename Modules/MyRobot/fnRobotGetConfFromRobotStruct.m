function afConf = fnRobotGetConfFromRobotStruct(strctRobot)
iNumLinks = size(strctRobot.m_a2fDH,1);
afConf = zeros(1,iNumLinks);
for iLinkIter=1:iNumLinks
    if strctRobot.m_a2fDH(iLinkIter,5) == 0
        afConf(iLinkIter) = strctRobot.m_astrctJointsDescription(iLinkIter).m_fValue/180*pi;
    else
        afConf(iLinkIter) = strctRobot.m_astrctJointsDescription(iLinkIter).m_fValue;
    end
end
return;