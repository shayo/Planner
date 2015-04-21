function a2fT = fnRobotForward(strctRobot, afConf)
% Construct the transformation
iNumJoints = size(strctRobot.m_a2fDH,1);
a2fT = strctRobot.m_a2fBase;
for iLinkIter=1:iNumJoints  
    a2fLink = fnRobotLinkTransformation( strctRobot.m_a2fDH(iLinkIter,:), afConf(iLinkIter));
    a2fT = a2fT* a2fLink;
end
a2fT = a2fT * strctRobot.m_a2fTool;
return;

