function a2fM = fnFreesurferToPlanner(strctVol)
% Inputs volumes can have very weird orientations.
% Here, we try to correct for such weird orientations by applying a 
% transformation that will map things back to "coronally" slices volumes. 

a2fM = strctVol.tkrvox2ras;
% a2fM(1:3,1:3) = strctTransform.m_a2fLeft*strctVol.vox2ras0(1:3,1:3)*strctTransform.m_a2fRight;
% a2fM(1:3,4) = strctVol.tkrvox2ras(1:3 ,4); 
return;
