strctArm = fnKopf1460LeftArm()

T = fnRobotForward(strctArm, zeros(1,8));
v = T(1:3,3);
p = T(1:3,4);
