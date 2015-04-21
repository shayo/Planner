#include <stdio.h>
#include <math.h>
#include "mex.h"

#define TRI(x,y,z,V000,V010,V100,V110,V001,V011,V101,V111) (( (V000) * (1-z)+(V001) * (z))*(1-y)+( (V010) * (1-z)+(V011) * (z))*(y)) * (1-x) + (( (V100) * (1-z)+(V101) * (z))*(1-y)+( (V110) * (1-z)+(V111) * (z))*(y))*(x)
#define MAX(x,y)(x>y)?(x):(y)
#define NAN 0
#define ACCESS_VOLUME(vol, indx, maxindx)(indx>=0 && indx<maxindx) ? vol[indx] : NAN;

/* This dll is the implementation of fndllFastInterp3 function.
It is a fast implementation of interp3. The advantage is that we do not need to pass
as arguments the volume grid. It is assumed that input volume coordinates are 1..N,1..M,1..Z
% Input type is float
% Output type is float
*/

template<class T> void CalcInterpolation(T* input_volume, float *output_vector, 
										 int iNumPoints, double *rows, double *cols, double *slices,int in_rows,int in_cols,int in_slices  ) {
	float V000,V001,V010,V011,V100,V101,V110,V111;
	int curr_row, curr_col, curr_slice;
	double dx,dy,dz;
	
	int in_sliceoffset = in_rows * in_cols;
	int num_input_voxels = in_slices * in_cols * in_rows;

	for (int iPointIter = 0; iPointIter < iNumPoints; iPointIter++) {

		curr_row = int(floor(rows[iPointIter]-1));
		curr_col = int(floor(cols[iPointIter]-1));
		curr_slice  = int(floor(slices[iPointIter]-1));
        
        if ( !(curr_row >= 0 & curr_col >= 0 & curr_slice >= 0 & curr_row < in_rows & curr_col <in_cols &  curr_slice< in_slices))
            continue;
        
		dy = (rows[iPointIter]-1) -curr_row; 
		dx = (cols[iPointIter]-1) -curr_col; 
		dz = (slices[iPointIter]-1) -curr_slice; 

		int in_curpos = curr_slice*in_sliceoffset + curr_col*in_rows + curr_row;
		V000 = ACCESS_VOLUME(input_volume,in_curpos+0, num_input_voxels);
		V010 = ACCESS_VOLUME(input_volume,in_curpos+1, num_input_voxels);
		V100 = ACCESS_VOLUME(input_volume,in_curpos+in_rows, num_input_voxels);
		V110 = ACCESS_VOLUME(input_volume,in_curpos+in_rows+1, num_input_voxels);
		V001 = ACCESS_VOLUME(input_volume,in_curpos+in_sliceoffset+0, num_input_voxels);
		V011 = ACCESS_VOLUME(input_volume,in_curpos+in_sliceoffset+1, num_input_voxels);
		V101 = ACCESS_VOLUME(input_volume,in_curpos+in_sliceoffset+in_rows, num_input_voxels);
		V111 = ACCESS_VOLUME(input_volume,in_curpos+in_sliceoffset+in_rows+1, num_input_voxels);
		output_vector[iPointIter] = float(TRI(dx, dy, dz, V000,V010,V100,V110,V001,V011,V101,V111));
	}
}

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
	if (nlhs != 1 || nrhs != 4) {
		mexErrMsgTxt("Usage: [afValues] = fndllFastInterp3(a3fVolume, Cols,Rows,Slices)");
		return;
	} 

	/* Get the number of dimensions in the input argument. */
	if (mxGetNumberOfDimensions(prhs[0]) != 3) {
		mexErrMsgTxt("Input volume must be 3D. ");
		return;
	}

	const int *input_dim_array = mxGetDimensions(prhs[0]);
	int in_rows = input_dim_array[0];
	int in_cols = input_dim_array[1];
	int in_slices = input_dim_array[2];

	double *rows = (double *)mxGetData(prhs[2]);
	double *cols = (double *)mxGetData(prhs[1]);
	double *slices = (double *)mxGetData(prhs[3]);

	const int *tmp = mxGetDimensions(prhs[1]);
	int iNumPoints = MAX(tmp[0], tmp[1]);

	if (iNumPoints == 0) {
		mexErrMsgTxt("Please provide at least one coordinate. ");
		return;
	}

	int output_dim_array[2];
	output_dim_array[0] = iNumPoints;
	output_dim_array[1] = 1;
	plhs[0] = mxCreateNumericArray(2, output_dim_array, mxSINGLE_CLASS, mxREAL);
	float *output_vector = (float*)mxGetPr(plhs[0]);

	
	if (mxIsSingle(prhs[0])) {
		float *input_volume = (float*)mxGetData(prhs[0]);
		CalcInterpolation(input_volume, output_vector,iNumPoints, rows, cols, slices,in_rows,in_cols, in_slices);
	}

	if (mxIsDouble(prhs[0])) {
		double *input_volume = (double*)mxGetData(prhs[0]);
		CalcInterpolation(input_volume, output_vector,iNumPoints, rows, cols, slices,in_rows,in_cols, in_slices);
	}

	if (mxIsUint16(prhs[0]) || mxIsInt16(prhs[0])) {
		short *input_volume = (short*)mxGetData(prhs[0]);
		CalcInterpolation(input_volume, output_vector,iNumPoints, rows, cols, slices,in_rows,in_cols, in_slices);
	}

	if ( mxIsUint8(prhs[0]) || mxIsLogical(prhs[0])) {
		unsigned char *input_volume = (unsigned char *)mxGetData(prhs[0]);
		CalcInterpolation(input_volume, output_vector,iNumPoints, rows, cols, slices,in_rows,in_cols, in_slices);
	}

}