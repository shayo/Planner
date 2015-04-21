function strctRobot = fnRobotCreate(a2fDH, a2fBase, a2fTool,strName,astrctJointDescirptions)
strctRobot.m_a2fDH = a2fDH;
if ~exist('a2fBase','var')
    a2fBase = eye(4);
end;
if ~exist('a2fTool','var')
    a2fTool = eye(4);
end;

strctRobot.m_a2fBase = a2fBase;
strctRobot.m_a2fTool = a2fTool;
strctRobot.m_strName = strName;
%strctRobot.m_a2fEarBarZeroToFrame = a2fEarBarZeroToFrame;
strctRobot.m_astrctJointsDescription = astrctJointDescirptions;
return;
