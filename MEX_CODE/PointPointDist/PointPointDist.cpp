#include <stdio.h>
#include <math.h>
#include "mex.h"

#define TRI(x,y,z,V000,V010,V100,V110,V001,V011,V101,V111) (( (V000) * (1-z)+(V001) * (z))*(1-y)+( (V010) * (1-z)+(V011) * (z))*(y)) * (1-x) + (( (V100) * (1-z)+(V101) * (z))*(1-y)+( (V110) * (1-z)+(V111) * (z))*(y))*(x)
#define MAX(x,y)(x>y)?(x):(y)
#define NAN 0


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
	if (nlhs != 2 || nrhs != 2) {
		mexErrMsgTxt("Usage: [afDist, aiMatchingInd] = fndllPointPointDist(Pa [3xN], Pb [3xM])");
		return;
	} 

	const int *dim1 = mxGetDimensions(prhs[0]);
	int NumA = dim1[1];
	const int *dim2 = mxGetDimensions(prhs[1]);
	int NumB = dim2[1];

	if (dim1[0] != 3 || dim2[0] != 3) {
		mexErrMsgTxt("Usage: [afDist, aiMatchingInd] = fndllPointPointDist(Pa [3xN], Pb [3xM])");
		return;
	}

	double *Pa = (double *)mxGetData(prhs[0]);
	double *Pb = (double *)mxGetData(prhs[1]);

	int output_dim_array[2];
	output_dim_array[0] = NumA;
	output_dim_array[1] = 1;
	plhs[0] = mxCreateNumericArray(2, output_dim_array, mxDOUBLE_CLASS, mxREAL);
	double *afMinDist = (double*)mxGetPr(plhs[0]);

	plhs[1] = mxCreateNumericArray(2, output_dim_array, mxDOUBLE_CLASS, mxREAL);
	double *aiMatchingInd = (double*)mxGetPr(plhs[1]);

	if (!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1])) {
		mexErrMsgTxt("Inputs must be double!");
	}

	for (int i=0;i<NumA;i++) {

		double Ax = Pa[3*i+0];
		double Ay = Pa[3*i+1];
		double Az = Pa[3*i+2];

		double M = 1e20;
		int iMinInd = 0;
		for (int j =0; j<NumB;j++) {
			double Bx = Pb[3*j+0];
			double By = Pb[3*j+1];
			double Bz = Pb[3*j+2];

			double D = sqrt( (Ax-Bx)*(Ax-Bx)+(Ay-By)*(Ay-By)+(Az-Bz)*(Az-Bz) );
			if (D < M) {
				M = D;
				iMinInd = j+1;
			}
			// Compute distance
		}
		afMinDist[i] = M;
		aiMatchingInd[i] = iMinInd;


	}

}

/*
addpath('D:\Code\Doris\MRI\planner\trunk\Code\MEX\')
load('D:\Code\Doris\MRI\planner\trunk\Code\DbgPT.mat')
[afMinDist, aiMatchingInd] = fndllPointPointDist(Pnrm', DirSphere');

*/