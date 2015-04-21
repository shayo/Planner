strSessionName = 'C:\Users\shayo\SkyDrive\Planner\Data\PlannerSessionBert.mat';
PlannerAPI('StartPlanner');
bSuccessful = PlannerAPI('LoadSession', strSessionName);
M=PlannerAPI('GetCrossSectionMatrix','horizontal');
WidthMM = 50;
I=PlannerAPI('RenderCrossSection', 1,[],M,WidthMM);

figure(2);
clf;
imshow(I,[]);

   
