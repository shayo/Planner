% Script ot register the atlas to a volume...

strFileName ='/space/data/shayo/cooked/test/mri/nu.mgz';

Y= AtlasReg(strFileName);

strFileName ='D:\Data\Doris\Planner\FreeSurfer Pipeline\nu.mgz';

[V,F]=read_surf('D:\Data\Doris\Planner\FreeSurfer Pipeline\lh.orig.nofix');
X.vertices = V;
X.faces = F+1;
figure;patch(X,'facecolor','r','edgecolor','none');
lighting  GOURAUD
