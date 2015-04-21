// SolidWorkRecordingChamber.cpp : main project file.

//#include "stdafx.h"
#include "atlbase.h"
#include "atlsafe.h"
#include <mex.h>

#include <ctime>
#include <iostream>
#include <string>
#include <sstream>

#include <list>
#define _USE_MATH_DEFINES
#include <math.h>

#include "SolidWorksRecordingChamber.h"



//HKEY_LOCAL_MACHINE\SOFTWARE\SolidWorks\SolidWorks 2012


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {

	if (nlhs != 1 || nrhs != 7) {
		mexErrMsgTxt("Usage: [Error] = fndllSolidWorks(XY (2xN), Tilt (1xN), Rotation (1xN), Rad (1xN), strTemplate, strOutputFile, bShutdown)");
		return;
	} 

	const int *dim1 = mxGetDimensions(prhs[0]);
	int NumHoles = dim1[1];
	const int *dim2 = mxGetDimensions(prhs[1]);
	const int *dim3 = mxGetDimensions(prhs[2]);

	if (dim1[0] != 2 || dim2[0] != 1 || dim1[1] != dim2[1] || dim3[1] != NumHoles) {
		mexErrMsgTxt("Usage: [Error] = fndllSolidWorks(XY (2xN), Tilt (1xN), Rotation (1xN), Rad (1xN), strTemplate, strOutputFile, bShutdown)");
		return;
	}

	//static const double HOLE_RADIUS_M = .375*MM_TO_M;


	double *P = (double *)mxGetData(prhs[0]);
	double *Tilt = (double *)mxGetData(prhs[1]);
	double *Rot = (double *)mxGetData(prhs[2]);

	double *Rad = (double *)mxGetData(prhs[3]);

	char TemplateFile[1000], OutputFile[1000];
	
	mxGetString(prhs[4], TemplateFile, 999);
	mxGetString(prhs[5], OutputFile, 999);

	bool bShutdown = (*(char *)mxGetData(prhs[6])) > 0;

        std::string saveFilename(OutputFile);
		std::string templateFileName(TemplateFile);

        vector<double> x_mm_list;
        vector<double> y_mm_list;
		vector<double> r_mm_list;

        vector<double > tilt_degrees_list;
        vector<double> rotation_degrees_list;

		for(int i = 0; i< NumHoles;i++) {

                        double tilt_degrees = Tilt[i];
                        double rotation_degrees = Rot[i];

                        double x = P[2*i+0];
                        double y = P[2*i+1];
						double r = Rad[i] ;

                        x_mm_list.push_back(x);
                        y_mm_list.push_back(y);
						r_mm_list.push_back(r);
                        tilt_degrees_list.push_back(tilt_degrees);
                        rotation_degrees_list.push_back(rotation_degrees);
        }

        int Err = createRecordingChamber(x_mm_list,
                               y_mm_list,
							   tilt_degrees_list,
							   rotation_degrees_list,
							   r_mm_list,
							   saveFilename, templateFileName,bShutdown);

		int output_dim_array[2] = {1,1};
	plhs[0] = mxCreateNumericArray(2, output_dim_array, mxDOUBLE_CLASS, mxREAL);
	double *Out = (double*) mxGetPr(plhs[0]);
	*Out = Err;

}




/**  createRecordingChamber - This is the main function for generating
a new SolidWorks model

                This function takes 4 vectors are input
                                1. x position (Planner coordinates)
                                2. y position (Planner coordinates)
                                3. tilt angle
                                4. rotation angle

                The 'ith' entry in these four vectors will correspond to the
                                'ith' desired grid location and orientation


                This function will:
                                1. Open SolidWorks
                                2. Load the template model located at TEMPLATE_FILENAME
                                3. Insert each of the desired grid holes
                                4. Save SolidWorks model with the same filename as TEMPLATE_FILENAME
                                                but with 'Template' replaced with the date
*/

int createRecordingChamber(vector<double> x_mm_list,
						   vector<double> y_mm_list,
						   vector<double> tilt_degrees_list,
						   vector<double> rotation_degrees_list,
						   vector<double> hole_radius_list,
						   std::string saveFilename, std::string templateFilename, bool bShutdown) {



         CoInitialize(NULL);
	
		debugPrintout("Initialize necessary Solidworks variables");
        CComPtr<ISldWorks> swApp;
        CComPtr<IModelDoc2> swModel;
        CComPtr<IModelDocExtension> swModelDocExt;
        CComPtr<IFeatureManager> swFeatureManager;
        CComPtr<ISketchManager> swSketchManager;
        CComPtr<ISelectionMgr> swSelectionMgr;

        long lErrors;
        long lWarnings;

        debugPrintout("Open SolidWorks");


        CComBSTR sAssemblyName(templateFilename.c_str());
        CComBSTR sDefaultConfiguration(L"Default");

   	    mexPrintf("Attempting to launch Solidworks and load template file...\n");
		mexEvalString("drawnow;");
        HRESULT Res = swApp.CoCreateInstance(__uuidof(SldWorks),NULL, CLSCTX_LOCAL_SERVER);
		if (Res == REGDB_E_CLASSNOTREG) {
			CoUninitialize();
			return 2;
		}
		Sleep(3000);
      try {
  
        swApp->OpenDoc6(sAssemblyName, swDocASSEMBLY, swOpenDocOptions_Silent,
                sDefaultConfiguration, &lErrors, &lWarnings, &swModel);

                handleTemplateLoadingError(lErrors);
		   	    mexPrintf("Template Loaded Successfully\n");
        }
        catch(char * error) {
			CoUninitialize();
                mexPrintf("%s\n",error);
                return 1;
        }
		mexEvalString("drawnow;");
        // Load Variables and settings

		debugPrintout("Load Variables and settings");
        swApp->get_IActiveDoc2(&swModel);
        swApp->put_UserControl(VARIANT_TRUE);
        swApp->put_Visible(VARIANT_TRUE);
        swApp->SetUserPreferenceToggle(swInputDimValOnCreate, VARIANT_FALSE);

		swModel->get_ISelectionManager(&swSelectionMgr);
        swModel->get_Extension(&swModelDocExt);
        swModel->get_FeatureManager(&swFeatureManager);
        swModel->get_SketchManager(&swSketchManager);

      


        swModel->SetAddToDB(true);


        // Insert Grid into SolidWorks Model
		debugPrintout("Generate Grid");

        insertGrid(x_mm_list, y_mm_list, tilt_degrees_list, rotation_degrees_list, hole_radius_list,
                swModel, swModelDocExt, swFeatureManager, swSketchManager);

        //std::cout << "Saving File As: " << endl << saveFilename << endl << endl;

		debugPrintout("Saving Grid");
        VARIANT_BOOL saveSuccessfulSLDPART;
		swModel->SaveAs(CComBSTR(saveFilename.c_str()), &saveSuccessfulSLDPART);

 		/*
        if (saveSuccessfulSTL && saveSuccessfulSLDPART)
                std::cout << "Save Successful" << endl << endl;
        else {
                std::cout << "Error Occured While Saving" << endl;
                return 2;
        }
		*/

        if (saveSuccessfulSLDPART)
				mexPrintf("Save Successful\n");
        else {
                mexPrintf("Error Occured While Saving\n");
                return 2;
        }
		if (bShutdown) {
			mexPrintf("Shutting down Solidworks !!\n");
			VARIANT_BOOL IncludeUnsaved = true, Retval;
			swApp->CloseAllDocuments(IncludeUnsaved, &Retval);
			swApp->ExitApp();
			//delete swApp;
		}

       swApp = NULL;
        CoUninitialize();

        return 0;
}






/**  insertGrid  - This function will cut out the grid specified by
					the (x, y, tilt, rotation) positions

        Note: This function assumes the Solidworks model has already been loaded
                  Also, x and y positions should be given in terms of Planner orientation:
                                                    z
                                                    |_ y
                                                   /
                                                  x
        Input -

                list<double> x_mm_list,                              - List of x positions (Planner)
                list<double> y_mm_list,                              - List of y positions (Planner)
                list<double> tilt_degrees_list,
                list<double> rotation_degrees_list,


                CComPtr<IModelDoc2> swModel,                         - Solidworks stuff....
                CComPtr<IModelDocExtension> swModelDocExt,
                CComPtr<IFeatureManager> swFeatureManager,
                CComPtr<ISketchManager> swSketchManager

*/

void insertGrid(vector<double> x_mm_list,
                                  vector<double> y_mm_list,
                                  vector<double> tilt_degrees_list,
                                  vector<double> rotation_degrees_list,
								  vector<double> hole_radius_list,
                                  CComPtr<IModelDoc2> swModel,
                                  CComPtr<IModelDocExtension> swModelDocExt,
                                  CComPtr<IFeatureManager> swFeatureManager,
                                  CComPtr<ISketchManager> swSketchManager) {

        int n = x_mm_list.size();

        for(int hole_number = 1; hole_number<=n; hole_number++) {

                double x_mm = x_mm_list[hole_number-1];
                double y_mm = y_mm_list[hole_number-1];
				double r_mm = hole_radius_list[hole_number-1];

                double tilt_degrees             = tilt_degrees_list[hole_number-1];
                double rotation_degrees = rotation_degrees_list[hole_number-1];

                // Display Grid Info
				mexPrintf("Punching hole %d / %d at position [%.2f, %.2f], rotation: %.2f, tilt = %.2f \n",
					hole_number,n,x_mm,y_mm, rotation_degrees,tilt_degrees);
				mexEvalString("drawnow;");
					
            insertIndividualGridHole(hole_number, x_mm, y_mm, tilt_degrees, rotation_degrees,r_mm,
                        swModel, swModelDocExt, swFeatureManager, swSketchManager);

        }

}



/** insertIndividualGridHole - This function will cut out a grid hole
at position (x,y) with the desired tilt and rotation

                This process involves:

                        1. Inserting grid location
                        2. Generating the Sketch Plane at the grid location and angle
                        3. Sketching the grid circle on this plane
                        4. Aligning that circle to the grid location
                        5. Extruding that cut through the model

*/

void insertIndividualGridHole(int hole_number,
							  double x_mm,
							  double y_mm,
							  double tilt_degrees,
							  double rotation_degrees,
							  double HoleRadiusMM,
							  CComPtr<IModelDoc2> swModel,
							  CComPtr<IModelDocExtension> swModelDocExt,
							  CComPtr<IFeatureManager> swFeatureManager,
							  CComPtr<ISketchManager> swSketchManager) {



		debugPrintout("Inserting Grid Location");
        CComPtr<ISketchPoint> swGridLocation =
                insertGridLocation(x_mm, y_mm, swModel, swFeatureManager);

		debugPrintout("Inserting Sketch Plane");
        insertSketchPlane(swGridLocation, tilt_degrees, rotation_degrees-90, swModel, swFeatureManager);

		debugPrintout("Inserting Sketch Segment");
        CComPtr<ISketchSegment> swSketchSegment =
                sketchGridHole(hole_number, swModel, swModelDocExt, swSketchManager,HoleRadiusMM);

		debugPrintout("Aligning Sketch");
        alignSketchToGridOrigin(swGridLocation, swSketchSegment, swModel, swSketchManager);

		debugPrintout("Extruding Cut");
        extrudeGridHole(swSketchSegment, swModel);

}





CComPtr<ISketchPoint> insertGridLocation(double x_mm_planner,
										 double y_mm_planner,
										 CComPtr<IModelDoc2> swModel,
										 CComPtr<IFeatureManager> swFeatureManager) {

/*
        The original SolidWorks model was created on a rotated axis.

        In Planner 3D space the axis is as follows (pardon the crude ASCI) :
                                                   z'
                                                   |_ y'
                                                  /
                                                 x'

		In our Solidworks model, the axis is as follows:

                                                  y_sw
                                                   |_ x_sw
                                                  /
                                                z_sw

		To convert from Planner coordinates to Solidworks, use the
			following transformation:

                                                x_sw = y'
                                                y_sw = z'
                                                z_sw = x'

*/

        // Convert from Planner orientation to Solidworks orientation

        double x_sw = y_mm_planner*MM_TO_M;
        double y_sw = PLANE_HEIGHT_MM*MM_TO_M;
        double z_sw = x_mm_planner*MM_TO_M;


        CComPtr<IDispatch> swSketchGridLocationUnknown;
        CComPtr<ISketchPoint> swSketchGridLocation;

        insureExecution(swModel->Insert3DSketch2(VARIANT_TRUE), __LINE__);
        insureExecution(swModel->CreatePoint2(x_sw, y_sw, z_sw, &swSketchGridLocationUnknown), __LINE__);

        swSketchGridLocation = swSketchGridLocationUnknown;
        return swSketchGridLocation;
}




/** insertPlane - Will create a reference plane tangent to the normal
					vector defined by the tilt and rotation angle.

			This plane will intersect the model at the grid location.
			
			This plane will be used to sketch the grid hole.



        Note:  This function accepts 'x' and 'y' dimensions in Planner
				orientation. These do not match the orientation used in
				the SolidWorks model. The transformation is accomplished here.


        Output: This function will output the SolidWorks ISketchPoint that
				corresponds to the desired grid location. This is helpful 
				in downstream functions.
*/

void insertSketchPlane(CComPtr<ISketchPoint> swGridLocation,
                       double tilt_degrees,
                       double rotation_degrees,
                       CComPtr<IModelDoc2> swModel,
                       CComPtr<IFeatureManager> swFeatureManager) {


        /*
                Using the tilt and rotation angle as a normal vector, we can compute the
                two orthonormal vectors that span the tangent plane.

                To define this plane in Solidworks we need to specify three points:

                        1. Grid Location
                        2. Grid Location + 1st vector in tanget plane
                        3. Grid Location + 2nd vector in tanget plane
        */

        vector<vector<double>> tangentPlane = computeTangentPlane(tilt_degrees, rotation_degrees);
        vector<double> v1 = tangentPlane[0];
        vector<double> v2 = tangentPlane[1];

        double x;
        double y;
        double z;

        swGridLocation->get_X(&x);
        swGridLocation->get_Y(&y);
        swGridLocation->get_Z(&z);


        // We want this reference plane to be 1mm squared (for display purposes)
        // SolidWorks requires dimensions to be in meters
        // These vectors are orthonormal (length 1)
        // If we assume it to be in units of mm, we need to convert them to meters

        double point1_x = x+v1[0]*MM_TO_M;
        double point1_y = y+v1[1]*MM_TO_M;
        double point1_z = z+v1[2]*MM_TO_M;

        double point2_x = x+v2[0]*MM_TO_M;
        double point2_y = y+v2[1]*MM_TO_M;
        double point2_z = z+v2[2]*MM_TO_M;


        // Solidworks

        CComPtr<IDispatch> swSketchPoint1Unknown;
        CComPtr<IDispatch> swSketchPoint2Unknown;

        CComPtr<ISketchPoint> swSketchPoint1;
        CComPtr<ISketchPoint> swSketchPoint2;


        VARIANT_BOOL returnBoolean;

        insureExecution(swModel->CreatePoint2(point1_x, point1_y, point1_z, &swSketchPoint1Unknown), __LINE__);
        insureExecution(swModel->CreatePoint2(point2_x, point2_y, point2_z, &swSketchPoint2Unknown), __LINE__);

        swSketchPoint1 = swSketchPoint1Unknown;
        swSketchPoint2 = swSketchPoint2Unknown;

        insureExecution(swModel->Insert3DSketch2(VARIANT_TRUE), __LINE__);

        // Select the three points, and generate intersecting plane

        insureExecution(swModel->ClearSelection(), __LINE__);

        insureExecution(swGridLocation->Select2(true, 0, &returnBoolean), __LINE__);
        insureExecution(swSketchPoint1->Select2(true, 1, &returnBoolean), __LINE__);
        insureExecution(swSketchPoint2->Select2(true, 2, &returnBoolean), __LINE__);

        CComPtr<IDispatch> swUnknown;
        CComPtr<IRefPlane> swRefPlane;

        insureExecution(swModel->CreatePlaneThru3Points3(true, &swUnknown), __LINE__);

        insureExecution(swModel->ClearSelection(), __LINE__);

        swRefPlane = swUnknown;

}






/** computeTangentPlane - This function will compute the two orthonormal vectors that span the
						  tangent plane to the normal vector defined by the 'tilt' and 'rotation' 
						  angles

                Note: This function uses Gram-Schmidt to calculate these vectors. 
					  
					  This algorithm makes the assumption that 'tilt' is not equal 
					  to 90 degrees (unfeasible for a recording chamber anyways)

*/

vector<vector<double>> computeTangentPlane(double tilt_degrees, 
										   double rotation_degrees) {

        double r = 1;

        double tilt_radians = tilt_degrees*DEGREES_TO_RADIANS;
        double rotation_radians = rotation_degrees*DEGREES_TO_RADIANS;

        // For Gram-Schmidt to work, we need a set of three independent vectors.
        // The normal vector is given, so we generate the other two by adding the
        //   vectors [1, 0, 0] and [0, 0, 1].

        // These two vectors are independent of each other, and of the normal vector
        //   as long as the tilt angle is not equal to PI/2.

        // PI/2 is also an invalid angle for our model (Grid would come out the side)

        if(tilt_radians == M_PI/2)
                throw "INVALID TILT ANGLE: PI/2";



        /* Initialize Gram-Schmidt


         To convert from Planner coordinates to Solidworks, use the following transformation:

         The original SolidWorks model was created on a rotated axis.
        
		 In Planner 3D space the axis is as follows (pardon the crude ASCI) :
                                                   z'
                                                   |_ y'
                                                  /
                                                 x'

		 In our Solidworks model, the axis is as follows:

                                                  y_sw
                                                   |_ x_sw
                                                  /
                                                z_sw

                              x_sw = y' = r*sin(rotation)*sin(tilt)
							  y_sw = z' = r*cos(tilt)
							  z_sw = x' = r*cos(rotation)*sin(tilt)
		*/

        double v1[3]; // Normal Vector
        v1[0] = r*sin(rotation_radians)*sin(tilt_radians); // x
        v1[1] = r*cos(tilt_radians);                       // y
        v1[2] = -r*cos(rotation_radians)*sin(tilt_radians); // z

        double v2[3];
        v2[0] = v1[0]+1;
        v2[1] = v1[1]+0;
        v2[2] = v1[2]+0;

        double v3[3];
        v3[0] = v1[0]+0;
        v3[1] = v1[1]+0;
        v3[2] = v1[2]+1;

        vector<vector<double>> orthonormalBasis = computeGramSchmidt(v1, v2, v3);

        // The first vector in the orthonormal basis is the vector normal to our surface.
        // The last two vectors span our desired plane

        vector<vector<double>> normalPlane;
        normalPlane.push_back(orthonormalBasis[1]);
        normalPlane.push_back(orthonormalBasis[2]);

        return normalPlane;
}







/** computeGramSchmidt - This function will run the Gram-Schmidt
process on the 3 input vectors

        Output will be a vector of three orthonormal vectors
*/

vector<vector<double>> computeGramSchmidt(double v1[3], double v2[3],
double v3[3]) {

        double u1[3];
        u1[0] = v1[0];
        u1[1] = v1[1];
        u1[2] = v1[2];

        double projection12 = innerProduct(u1, v2)/innerProduct(u1, u1);
        double projection13 = innerProduct(u1, v3)/innerProduct(u1, u1);

        double u2[3];
        u2[0] = v2[0]-projection12*u1[0];
        u2[1] = v2[1]-projection12*u1[1];
        u2[2] = v2[2]-projection12*u1[2];

        double projection23 = innerProduct(u2, v3)/innerProduct(u2, u2);

        double u3[3];
        u3[0] = v3[0]-projection13*u1[0]-projection23*u2[0];
        u3[1] = v3[1]-projection13*u1[1]-projection23*u2[1];
        u3[2] = v3[2]-projection13*u1[2]-projection23*u2[2];

        vector<double> e1;
        e1.push_back(u1[0]/sqrt(innerProduct(u1,u1)));
        e1.push_back(u1[1]/sqrt(innerProduct(u1,u1)));
        e1.push_back(u1[2]/sqrt(innerProduct(u1,u1)));

        vector<double> e2;
        e2.push_back(u2[0]/sqrt(innerProduct(u2,u2)));
        e2.push_back(u2[1]/sqrt(innerProduct(u2,u2)));
        e2.push_back(u2[2]/sqrt(innerProduct(u2,u2)));

        vector<double> e3;
        e3.push_back(u3[0]/sqrt(innerProduct(u3,u3)));
        e3.push_back(u3[1]/sqrt(innerProduct(u3,u3)));
        e3.push_back(u3[2]/sqrt(innerProduct(u3,u3)));

        vector<vector<double>> orthonormalBasis;
        orthonormalBasis.push_back(e1);
        orthonormalBasis.push_back(e2);
        orthonormalBasis.push_back(e3);

        return orthonormalBasis;

}




// Basic linear algebra
double innerProduct(double* v1, double* v2) {
        double output = v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2];
        return output;
}











/** sketchGridHole - draws a circle on the plane generated by function 'insertPlane'

        Note: the previous function 'insertSketchPlane' creates a new plane
				with an auto generated name 'Plane#' with # replaced with an
				incrementing number.

                To help locate this plane, this function requires the grid number.

        input:
               int grid_number,                                  -the sequential grid number (helps locate sketch plane)

               CComPtr<IModelDoc2> swModel,                                            - other necessary params...
			   CComPtr<IModelDocExtension> swModelDocExt,
			   CComPtr<ISketchManager> swSketchManager

**/

CComPtr<ISketchSegment> sketchGridHole(int grid_number,
									   CComPtr<IModelDoc2> swModel,
									   CComPtr<IModelDocExtension> swModelDocExt,
									   CComPtr<ISketchManager> swSketchManager, double HoleRadiusMM) {


        CComBSTR plane_type(L"PLANE");
        CComBSTR plane = "Plane";
        // Append plane number to the end of the 'plane' string
        char buffer [5];
        _itoa_s(grid_number, buffer, 10);
        plane.Append(buffer);

        CComPtr<IDispatch> swSketchSegmentUnknown;
        CComPtr<ISketchSegment> swSketchSegment;
        VARIANT_BOOL returnBoolean;
		
        insureExecution(swModel->ClearSelection(), __LINE__);
		
        insureExecution(swModelDocExt->SelectByID2(plane, plane_type, 0, 0, 0, true, 0, NULL, 0, &returnBoolean), __LINE__);
		
		swModel->CreateCircleByRadius2(0,0,0, HoleRadiusMM*MM_TO_M, &swSketchSegmentUnknown); // For some reason this always comes back false, so insuringExecution is not helpful
		
		swSketchSegment = swSketchSegmentUnknown;

        return swSketchSegment;
}












/** alignSketchToOrigin - shifts the grid hole to the desired location on the sketch

                When the grid circle is originally drawn by 'sketchGridHole' the sketch is not
                inserted at the desired location. This function will create a dimension between
                the sketch circle and the desired location, then set that dimension to zero.

        input:

                CComPtr<ISketchPoint> swGridOrigin                -   Desired Grid Origin
                CComPtr<ISketchSegment> swSketchSegment           -   Grid Hole Sketch

                CComPtr<IModelDoc2> swModel,                      -   other necessary params...
                CComPtr<ISketchManager> swSketchManager

**/

void alignSketchToGridOrigin(CComPtr<ISketchPoint> swGridLocation,
                                                 CComPtr<ISketchSegment> swSketchSegment,
                                                 CComPtr<IModelDoc2> swModel,
                                                 CComPtr<ISketchManager> swSketchManager) {

        CComPtr<IDispatch> swDisplayDimensionUnknown;
        CComPtr<IDisplayDimension> swDisplayDimension;

        CComPtr<IDispatch> swDimensionUnknown;
        CComPtr<IDimension> swDimension;

        VARIANT_BOOL selectSegment;
		VARIANT_BOOL selectGridLocation;

        long returnLong;

        insureExecution(swModel->ClearSelection(), __LINE__);
		
		
		insureExecution(swSketchSegment->Select(VARIANT_TRUE, &selectSegment), __LINE__);
        insureExecution(swGridLocation->Select(VARIANT_TRUE, &selectGridLocation), __LINE__);

        insureExecution(swModel->AddDimension2(0,0,0, &swDisplayDimensionUnknown), __LINE__);
        swDisplayDimension = swDisplayDimensionUnknown;

        if(swDisplayDimension == NULL) // If Sketch and GridLocation already line up, this object is null
                return;

        insureExecution(swDisplayDimension->GetDimension(&swDimensionUnknown), __LINE__);
        swDimension = swDimensionUnknown;

        insureExecution(swDimension->SetValue2(0, swThisConfiguration, &returnLong), __LINE__);

        insureExecution(swSketchManager->InsertSketch(VARIANT_TRUE), __LINE__);

}












void extrudeGridHole(CComPtr<ISketchSegment> swSketchSegment,
                                         CComPtr<IModelDoc2> swModel) {

        VARIANT_BOOL returnBoolean;

        insureExecution(swModel->ClearSelection(), __LINE__);
        insureExecution(swSketchSegment->Select(VARIANT_TRUE, &returnBoolean), __LINE__);

        bool single_sided = false;
        bool flip_cut = false;
        bool reverse_dir = false;

        double depth1 = 0; // End Condition is ThroughAll so no depth is needed
        double depth2 = 0;

        // Not entirely sure what the rest of these parameters do, but we don't need them
        bool draft1 = false;
        bool draft2 = false;
        bool draft_dir1 = false;
        bool draft_dir2 = false;
        double draft_angle1 = 0;
        double draft_angle2 = 0;

        bool offset1 = false;
        bool offset2 = false;

        insureExecution(swModel->FeatureCut(single_sided,
                            flip_cut,
							reverse_dir,
							swEndCondThroughAll,
							swEndCondThroughAll,
							depth1,
							depth2,
							draft1,
							draft2,
							draft_dir1,
							draft_dir2,
							draft_angle1,
							draft_angle2,
							offset1,
							offset2), __LINE__);


}











void handleTemplateLoadingError(long lError) {
        if(lError == swGenericError)
                throw "ERROR: Generic Error Occured While Loading Template";
        if(lError == swFileNotFoundError)
                throw "ERROR: Template File Not Found -> UPDATE 'TEMPLATE_FILENAME' VARIABLE\n";
}



void insureExecution(HRESULT actionOutput, int lineNumber) {
	if(actionOutput != S_OK) {
		mexPrintf("ERROR: Solidworks action did not successfully execute. Line %i\n", lineNumber);
	}
}


void debugPrintout(std::string outputString) {
	if(VERBOSE) {
		mexPrintf(outputString.c_str());
		mexPrintf("\n");
	}
}
