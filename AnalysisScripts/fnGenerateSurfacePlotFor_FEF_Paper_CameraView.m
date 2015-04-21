function fnGenerateSurfacePlotFor_FEF_Paper_CameraView(iMode)
% ax=gca
% 
% darSave = get(ax, 'dataaspectratio');
% cpSave  = get(ax, 'cameraposition' );
% ctSave  = get(ax, 'cameratarget'   );
% upSave  = get(ax, 'cameraupvector' );
% cvaSave = get(ax, 'cameraviewangle');
if iMode == 0
set(gca,'dataaspectratio', [1 1 1],'cameraposition',[     -1741        -464        -111],'cameratarget',[0 0 0],'cameraupvector',[  0.2639   -0.9273   -0.2655],'cameraviewangle', 2.1807);
elseif iMode == 1
    set(gca,'dataaspectratio', [1 1 1],'cameraposition',[   1521        -939        -258],'cameratarget',[0 0 0],'cameraupvector',[0.4847    0.8460   -0.2221],'cameraviewangle', 2.1807);
elseif iMode == 2
    set(gca,'dataaspectratio', [1 1 1],'cameraposition',[    1736         496           7],'cameratarget',[0 0 0],'cameraupvector',[  -0.2673    0.9385   -0.2185],'cameraviewangle', 2.1807);        
elseif iMode == 3
        set(gca,'dataaspectratio', [1 1 1],'cameraposition',[    -1432        1098          81],'cameratarget',[0 0 0],'cameraupvector',[  -0.5922   -0.7855    0.1800],'cameraviewangle', 2.1807);        
end
set(gcf,'color',[1 1 1],'position',[  302   546   560   420]);
axis off
