#include <stdio.h>
#include <math.h>
#include "mex.h"

#define outcode int
const int RIGHT = 8;  //1000
const int TOP = 4;    //0100
const int LEFT = 2;   //0010
const int BOTTOM = 1; //0001
 
//Compute the bit code for a point (x, y) using the clip rectangle
//bounded diagonally by (xmin, ymin), and (xmax, ymax)
outcode ComputeOutCode (double x, double y, double xmin, double xmax, double ymin, double ymax)
{
	outcode code = 0;
	if (y > ymax)              //above the clip window
		code |= TOP;
	else if (y < ymin)         //below the clip window
		code |= BOTTOM;
	if (x > xmax)              //to the right of clip window
		code |= RIGHT;
	else if (x < xmin)         //to the left of clip window
		code |= LEFT;
	return code;
}
 
//Cohen-Sutherland clipping algorithm clips a line from
//P0 = (x0, y0) to P1 = (x1, y1) against a rectangle with 
//diagonal from (xmin, ymin) to (xmax, ymax).
bool CohenSutherlandLineClip (double &x0, double &y0,double &x1, double &y1, double xmin, double xmax, double ymin, double ymax)
{
	//Outcodes for P0, P1, and whatever point lies outside the clip rectangle
	outcode outcode0, outcode1, outcodeOut;
	bool accept = false, done = false;
 
	//compute outcodes
	outcode0 = ComputeOutCode (x0, y0, xmin, xmax, ymin, ymax);
	outcode1 = ComputeOutCode (x1, y1, xmin, xmax, ymin, ymax);
 
	do{
		if (!(outcode0 | outcode1))      //logical or is 0. Trivially accept and get out of loop
		{
			accept = true;
			done = true;
		}
		else if (outcode0 & outcode1)//logical and is not 0. Trivially reject and get out of loop
                {
			done = true;
                }
 
		else
		{
			//failed both tests, so calculate the line segment to clip
			//from an outside point to an intersection with clip edge
			double x, y;
			//At least one endpoint is outside the clip rectangle; pick it.
			outcodeOut = outcode0? outcode0: outcode1;
			//Now find the intersection point;
			//use formulas y = y0 + slope * (x - x0), x = x0 + (1/slope)* (y - y0)
			if (outcodeOut & TOP)          //point is above the clip rectangle
			{
				x = x0 + (x1 - x0) * (ymax - y0)/(y1 - y0);
				y = ymax;
			}
			else if (outcodeOut & BOTTOM)  //point is below the clip rectangle
			{
				x = x0 + (x1 - x0) * (ymin - y0)/(y1 - y0);
				y = ymin;
			}
			else if (outcodeOut & RIGHT)   //point is to the right of clip rectangle
			{
				y = y0 + (y1 - y0) * (xmax - x0)/(x1 - x0);
				x = xmax;
			}
			else if (outcodeOut & LEFT)                         //point is to the left of clip rectangle
			{
				y = y0 + (y1 - y0) * (xmin - x0)/(x1 - x0);
				x = xmin;
			}
			//Now we move outside point to intersection point to clip
			//and get ready for next pass.
			if (outcodeOut == outcode0)
			{
				x0 = x;
				y0 = y;
				outcode0 = ComputeOutCode (x0, y0, xmin, xmax, ymin, ymax);
			}
			else 
			{
				x1 = x;
				y1 = y;
				outcode1 = ComputeOutCode (x1, y1, xmin, xmax, ymin, ymax);
			}
		}
	}while (!done);
 
	return accept;
}

mxArray* mxCreateScalar(double x) {
    mxArray* p = mxCreateDoubleMatrix(1,1,mxREAL);
    double*  ptr = mxGetPr(p);
    ptr[0] = x;
    return p;
}

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
	if (nlhs != 5 || nrhs !=8) {
		mexErrMsgTxt("Usage: [afX0_C,afX1_C,afY0_C,afY1_C, abIntersectRect] = fndllCohenSutherland(afX0, afX1, afY0, afY1, xmin,xmax,ymin,ymax)");
		return;
	}
	double *ax0 = (double *)mxGetData(prhs[0]);
	double *ax1 = (double *)mxGetData(prhs[1]);
	double *ay0 = (double *)mxGetData(prhs[2]);
	double *ay1 = (double *)mxGetData(prhs[3]);
	double xmin = *(double *)mxGetData(prhs[4]);
	double xmax = *(double *)mxGetData(prhs[5]);
	double ymin = *(double *)mxGetData(prhs[6]);
	double ymax = *(double *)mxGetData(prhs[7]);
	

	const int *inputdim = mxGetDimensions(prhs[0]);
	int iNumLines = inputdim[0] > inputdim[1] ? inputdim[0] : inputdim[1];

	int output_dim_array[2];
	output_dim_array[0] = 1;
	output_dim_array[1] = iNumLines;

	plhs[0] = mxCreateNumericArray(2, output_dim_array, mxDOUBLE_CLASS, mxREAL);
	double *outx0= (double*)mxGetPr(plhs[0]);
	plhs[1] = mxCreateNumericArray(2, output_dim_array, mxDOUBLE_CLASS, mxREAL);
	double *outx1= (double*)mxGetPr(plhs[1]);
	plhs[2] = mxCreateNumericArray(2, output_dim_array, mxDOUBLE_CLASS, mxREAL);
	double *outy0= (double*)mxGetPr(plhs[2]);
	plhs[3] = mxCreateNumericArray(2, output_dim_array, mxDOUBLE_CLASS, mxREAL);
	double *outy1= (double*)mxGetPr(plhs[3]);

	plhs[4] = mxCreateNumericArray(2, output_dim_array, mxLOGICAL_CLASS, mxREAL);
	unsigned char *abResult = (unsigned char*)mxGetPr(plhs[4]);

	double x0,y0,x1,y1;
	for (int iLineIter=0;iLineIter<iNumLines;iLineIter++) {

		x0 = ax0[iLineIter];
		x1 = ax1[iLineIter];
		y0 = ay0[iLineIter];
		y1 = ay1[iLineIter];
		abResult[iLineIter] = CohenSutherlandLineClip(x0,y0,x1,y1,xmin, xmax,ymin,ymax);
		outx0[iLineIter] = x0;
		outy0[iLineIter] = y0;
		outx1[iLineIter] = x1;
		outy1[iLineIter] = y1;

	}

}