% Generate a grid with varying grid hole diameters.
iNumHoles = 15;
[X,Y]=meshgrid(-5:5,-5:5);
TiltAngle = 15;
aiHoleDiameter = 0.79:0.005:0.84;
strRange = sprintf('%.2f-%.2f',aiHoleDiameter(1),aiHoleDiameter(end));
P=[X(:)';Y(:)'];
Tilt = ones(1, size(P,2))*TiltAngle;
Rot = zeros(1, size(P,2));
Rad = zeros(1, size(P,2));
for k=-5:5
    Rad( P(2,:) == k) = aiHoleDiameter(k+6)/2;
end
strTemplate='C:\Users\shayo\SkyDrive\Planner\Solidworks\Grid_Template.SLDPRT';
strOutputFile = ['C:\Users\shayo\SkyDrive\Planner\Solidworks\Grid_Modified_',num2str(TiltAngle),'_Deg_Dia_',strRange,'.SLDPRT'];
iErr = fndllSolidWorksRecordingChamber2013(P, Tilt, Rot, Rad, strTemplate, strOutputFile,true);


%%
afDeg     = [0,     5,    10,    15];
afPlastic = [0.725, 0.82, 0.83, 0.84
afMetal   = [0.69,  0.79, 0.81, 0.83
