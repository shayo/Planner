function bFeasible = fnRobotIsFeasible(strctRobot,afConf)
bFeasible = false;
for i=1:length(afConf)
    if strctRobot.m_a2fDH(i,5) == 0
        % Rotation
        if afConf(i)/180*pi < strctRobot.m_astrctJointsDescription(i).m_fMin || ...
                afConf(i)/180*pi > strctRobot.m_astrctJointsDescription(i).m_fMax
            return;
        end;
    else
        if afConf(i) < strctRobot.m_astrctJointsDescription(i).m_fMin || ...
                afConf(i) > strctRobot.m_astrctJointsDescription(i).m_fMax
            return;
        end;
    end
end
bFeasible = true;
    