#ifndef SOLIDWORKSRECORDINGCHAMBER
#define SOLIDWORKSRECORDINGCHAMBER

#include <vector>
#include <list>

// Set to :    disk:\<Solidworks_install_dir>\sldwords.tlb
#import "sldworks.tlb" raw_interfaces_only,    raw_native_types, no_namespace, named_guids

// Set to :    disk:\<Solidworks_install_dir>\swconst.tlb
#import "swconst.tlb" raw_interfaces_only, raw_native_types, no_namespace, named_guids

// Update to point to template file
//static const std::string SOLIDWORKS_LOCATION = "C:\\Users\\shayo\\Dropbox\\Planner Code\\Solidworks\\";
//static const std::string TEMPLATE_FILENAME = "RecordingChamber_Template";

//static const std::string SLDPART_FILETYPE = ".SLDPRT";
//static const std::string STL_FILETYPE = ".STL";

bool VERBOSE = TRUE;
static const double DEGREES_TO_RADIANS = M_PI/ (double) 180;
static const double MM_TO_M = (double) 1 / (double) 1000;

static const double PLANE_HEIGHT_MM = 10;


using namespace std;
//using namespace System;


void handleTemplateLoadingError(long lError);


int createRecordingChamber(vector<double> x_mm_list,
						   vector<double> y_mm_list,
						   vector<double> tilt_degrees_list,
						   vector<double> rotation_degrees_list,
						   vector<double> hole_radius_list,
						   std::string saveFilename, std::string templateFilename);




void insertGrid(vector<double> x_mm_list,
				vector<double> y_mm_list,
				vector<double> tilt_degrees_list,
				vector<double> rotation_degrees_list,
				vector<double> hole_radius_list,
				CComPtr<IModelDoc2> swModel,
				CComPtr<IModelDocExtension> swModelDocExt,
				CComPtr<IFeatureManager> swFeatureManager,
				CComPtr<ISketchManager> swSketchManager);




void insertIndividualGridHole(int i,
							  double x_mm,
							  double y_mm,
							  double tilt_degrees,
							  double rotation_degrees,
							  double HoleRadiusMM,
							  CComPtr<IModelDoc2> swModel,
							  CComPtr<IModelDocExtension> swModelDocExt,
							  CComPtr<IFeatureManager> swFeatureManager,
							  CComPtr<ISketchManager> swSketchManager);



CComPtr<ISketchPoint> insertGridLocation(double x_mm_planner,
										 double y_mm_planner,
										 CComPtr<IModelDoc2> swModel,
										 CComPtr<IFeatureManager> swFeatureManager);



void insertSketchPlane(CComPtr<ISketchPoint> swGridLocation,
					   double tilt_degrees,                                                                   
					   double rotation_degrees,
					   CComPtr<IModelDoc2> swModel,
					   CComPtr<IFeatureManager> swFeatureManager);





void extrudeGridHole(CComPtr<ISketchSegment> swSketchSegment,
					 CComPtr<IModelDoc2> swModel);



CComPtr<ISketchSegment> sketchGridHole(int grid_number,
									   CComPtr<IModelDoc2> swModel,
									   CComPtr<IModelDocExtension> swModelDocExt,
									   CComPtr<ISketchManager> swSketchManager, double HoleRadiusMM);






void alignSketchToGridOrigin(CComPtr<ISketchPoint> swGridOrigin,
							 CComPtr<ISketchSegment> swSketchSegment,
							 CComPtr<IModelDoc2> swModel,
							 CComPtr<ISketchManager> swSketchManager);


vector<vector<double>> computeTangentPlane(double tilt_degrees,
										   double rotation_degrees);

vector<vector<double> > computeGramSchmidt(double v1[3],
										   double v2[3],
										   double v3[3]);

double innerProduct(double* v1, double* v2);

void insureExecution(HRESULT actionOutput, int lineNumber);
void debugPrintout(std::string outputString);

#endif