strctGridFunc.m_strDefine = @fnDefineGridModel_DualCircular;
strctGridFunc.m_strBuildModel = @fnBuildGridModel_DualCircular;
strctGridFunc.m_strBuildMesh = @fnBuildGridMesh_DualCircular;
strctGridFunc.m_strDraw2D = @fnDraw2DGridModel_DualCircular;

strctPlannerInfo.m_iAnatomicalIndex = 1;
strctPlannerInfo.m_iChamberIndex = 1;
strctPlannerInfo.m_iGridIndex = 1;
strctPlannerInfo.m_strCallback = 'fnElectrodePlanningNewCallback';


strctGridParam = feval(strctGridFunc.m_strDefine);
strctGridParam=fnSetGridParameter(strctGridParam,'Phi1',10);
strctGridParam=fnSetGridParameter(strctGridParam,'Theta1',-10);
strctGridParam=fnSetGridParameter(strctGridParam,'Phi2',20);
strctGridParam=fnSetGridParameter(strctGridParam,'Theta2',10);


strctGridModel = feval(strctGridFunc.m_strBuildModel, strctGridParam);

figure(12);
clf;
feval(strctGridFunc.m_strDraw2D,strctGridModel, gca, []);

GridHelper('InitNewGrid',strctPlannerInfo, strctGridModel, strctGridFunc);

