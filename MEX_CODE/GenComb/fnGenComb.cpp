/*
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)
*/
#include <stdio.h>
#include "mex.h"

void fnBackTrackGenComb(int iDimX, int iDimY, int *RangeDim, double **Range, float *aiCurrComb,int iIndex, float *Out,int &iGlobalCounter) {
// Generates all vector of length N, with domain Range (N^M) using
// backtracking
//
	if (iIndex >= iDimX) {
		for (int k=0;k<iDimX;k++) {
			Out[k*iDimY+iGlobalCounter] = aiCurrComb[k];
		}
		iGlobalCounter++;
		return;
	}

	for (int j=0; j < RangeDim[iIndex];j++) {
		aiCurrComb[iIndex] = (float)Range[iIndex][j];
		fnBackTrackGenComb(iDimX, iDimY, RangeDim, Range, aiCurrComb, iIndex+1, Out, iGlobalCounter);
	}

	return;
}

void mexFunction( int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[] ) 
{

	int iDim = mxGetNumberOfElements(prhs[0]);

	int *aiLenDim = new int[iDim];
	double **Range = new double*[iDim];

	int iMult = 1;
	for (int k=0;k<iDim;k++) {
		mxArray *M = mxGetCell(prhs[0],k);
		aiLenDim[k] = mxGetNumberOfElements(M);
		Range[k] = (double*)mxGetPr(M);
		iMult*=aiLenDim[k];
	}

	mwSize OutDim[2] = {iMult,iDim} ;
	plhs[0] = mxCreateNumericArray(2, OutDim, mxSINGLE_CLASS, mxREAL);
	float *Out = (float*)mxGetPr(plhs[0]);

	float *aiCurrComb = new float[iDim];
	int iGlobalCounter = 0;
	fnBackTrackGenComb(iDim, iMult, aiLenDim, Range, aiCurrComb, 0, Out, iGlobalCounter);

    delete [] aiCurrComb ;
	delete [] aiLenDim;
	delete [] Range;

}
