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

template<class T> void CalcInterpolation(T* input_volume, float *output_vol, double *R,
										 const int *insize, double *outsize) {
	float V000,V001,V010,V011,V100,V101,V110,V111;
	int curr_row, curr_col, curr_slice;
	double dc,dr,ds;
	
	int in_rows = insize[0];
	int in_cols = insize[1];
	int in_slices = insize[2];
	int in_sliceoffset = in_rows * in_cols;
	int num_input_voxels = in_slices * in_cols * in_rows;
	int iNumRows = int(outsize[0]);
	int iNumCols = int(outsize[1]);
	int iNumSlices = int(outsize[2]);
	int iSliceOffset = iNumRows*iNumCols;

	double in_r,in_s,in_c;
	for (int out_s = 0; out_s < iNumSlices; out_s++) {
		int Offset = iSliceOffset * out_s;

		for (int out_r = 0; out_r < iNumRows; out_r++) {
			for (int out_c = 0; out_c < iNumCols; out_c++) {

				// [in_r, in_c, in_s] = R * [out_r, out_c, out_s,1]
//				R[0] R[4] R[8]   R[12]    out_c
//				R[1] R[5] R[9]   R[13]  * out_r
//				R[2] R[6] R[10]  R[14]    out_s
//				R[3] R[7] R[11]  R[15]      1
				
					
				in_c = R[0]*out_c + R[4]*out_r + R[8]*out_s +  R[12];
				in_r = R[1]*out_c + R[5]*out_r + R[9]*out_s +  R[13];
				in_s = R[2]*out_c + R[6]*out_r + R[10]*out_s + R[14] ;

				curr_row = int(floor(in_r));
				curr_col = int(floor(in_c));
				curr_slice = int(floor(in_s));
	
				ds = in_s - curr_slice;
				dr = in_r - curr_row;
				dc = in_c - curr_col;


		int in_curpos = curr_slice*in_sliceoffset + curr_col*in_rows + curr_row;
		V000 = ACCESS_VOLUME(input_volume,in_curpos+0, num_input_voxels);
		V010 = ACCESS_VOLUME(input_volume,in_curpos+1, num_input_voxels);
		V100 = ACCESS_VOLUME(input_volume,in_curpos+in_rows, num_input_voxels);
		V110 = ACCESS_VOLUME(input_volume,in_curpos+in_rows+1, num_input_voxels);
		V001 = ACCESS_VOLUME(input_volume,in_curpos+in_sliceoffset+0, num_input_voxels);
		V011 = ACCESS_VOLUME(input_volume,in_curpos+in_sliceoffset+1, num_input_voxels);
		V101 = ACCESS_VOLUME(input_volume,in_curpos+in_sliceoffset+in_rows, num_input_voxels);
		V111 = ACCESS_VOLUME(input_volume,in_curpos+in_sliceoffset+in_rows+1, num_input_voxels);

				output_vol[Offset + out_c*iNumRows + out_r] = float(TRI(dc, dr, ds, V000,V010,V100,V110,V001,V011,V101,V111));
			}	
		}
	}

}



void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
	if (nlhs != 1 || nrhs != 3) {
		mexErrMsgTxt("Usage: [afValues] = fndllFastInterp3Vol(InputVol, R=Transformation[4x4], aiOutSize[r,c,s])");
		// This will go over [1..r,1..c,1..s] and will compute:
		// R * [r-1,c-1,s-1]
		// It will then sample this from InputVol and store it in [r,c,s] in the output vol.
		return;
	} 

	/* Get the number of dimensions in the input argument. */
	if (mxGetNumberOfDimensions(prhs[0]) != 3) {
		mexErrMsgTxt("Input volume must be 3D. ");
		return;
	}

	const int *input_dim_array = mxGetDimensions(prhs[0]);

	double *R = (double *)mxGetData(prhs[1]);
	double *outsize = (double *)mxGetData(prhs[2]);

	int output_dim_array[3];
	output_dim_array[0] = outsize[0];
	output_dim_array[1] = outsize[1];
	output_dim_array[2] = outsize[2];
	plhs[0] = mxCreateNumericArray(3, output_dim_array, mxSINGLE_CLASS, mxREAL);
	float *output_vol = (float*)mxGetPr(plhs[0]);
	
	if (mxIsSingle(prhs[0])) {
		float *input_volume = (float*)mxGetData(prhs[0]);
		CalcInterpolation(input_volume, output_vol, R, input_dim_array, outsize);
	}

	if (mxIsDouble(prhs[0])) {
		double *input_volume = (double*)mxGetData(prhs[0]);
		CalcInterpolation(input_volume, output_vol, R, input_dim_array, outsize);
	}

	if (mxIsUint16(prhs[0]) || mxIsInt16(prhs[0])) {
		short *input_volume = (short*)mxGetData(prhs[0]);
		CalcInterpolation(input_volume, output_vol, R, input_dim_array, outsize);
	}

	if (mxIsUint8(prhs[0])) {
		unsigned char *input_volume = (unsigned char *)mxGetData(prhs[0]);
		CalcInterpolation(input_volume, output_vol, R, input_dim_array, outsize);
	}

}