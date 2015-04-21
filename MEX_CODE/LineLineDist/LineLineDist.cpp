#include <stdio.h>
#include <math.h>
#include "mex.h"

#define MAX(x,y)(x>y)?(x):(y)
#define NAN 0
#define EPS 1e-6


double GetSegmentDistance(double *Pa, double *Pb, int i, int j) { 

		double x1 = Pa[3*i+0];
		double y1 = Pa[3*i+1];
		double z1 = Pa[3*i+2];

		double x2 = Pb[3*i+0];
		double y2 = Pb[3*i+1];
		double z2 = Pb[3*i+2];

		double Cent1x = (x1+x2)/2;
		double Cent1y = (y1+y2)/2;
		double Cent1z = (z1+z2)/2;


		double Ax = x2-x1;
		double Ay = y2-y1;
		double Az = z2-z1;

		double Extent0 = sqrt(Ax*Ax+Ay*Ay+Az*Az) / 2;
		Ax/=2*Extent0;
		Ay/=2*Extent0;
		Az/=2*Extent0;

		double x3 = Pa[3*j+0];
		double y3 = Pa[3*j+1];
		double z3 = Pa[3*j+2];

		double x4 = Pb[3*j+0];
		double y4 = Pb[3*j+1];
		double z4 = Pb[3*j+2];


		double Cent2x = (x3+x4)/2;
		double Cent2y = (y3+y4)/2;
		double Cent2z = (z3+z4)/2;


		double Bx = x4-x3;
		double By = y4-y3;
		double Bz = z4-z3;

		double Extent1 = sqrt(Bx*Bx+By*By+Bz*Bz) / 2;

		Bx/=2*Extent1;
		By/=2*Extent1;
		Bz/=2*Extent1;

		double Cx = Cent1x-Cent2x;
		double Cy = Cent1y-Cent2y;
		double Cz = Cent1z-Cent2z;



    // The segment is represented as (1-s)*P0+s*P1, where P0 and P1 are the
    // endpoints of the segment and 0 <= s <= 1.
    //
    // Some algorithms involving segments might prefer a centered
    // representation similar to how oriented bounding boxes are defined.
    // This representation is C+t*D, where C = (P0+P1)/2 is the center of
    // the segment, D = (P1-P0)/Length(P1-P0) is a unit-length direction
    // vector for the segment, and |t| <= e.  The value e = Length(P1-P0)/2
    // is the 'extent' (or radius or half-length) of the segment.


//    Vector3<Real> diff = mSegment0->Center - mSegment1->Center; // now is C
//    Real a01 = -mSegment0->Direction.Dot(mSegment1->Direction); // now And B
//    Real b0 = diff.Dot(mSegment0->Direction);
//    Real b1 = -diff.Dot(mSegment1->Direction);
//    Real c = diff.SquaredLength();
//    Real det = Math<Real>::FAbs((Real)1 - a01*a01);
    double s0, s1, sqrDist, extDet0, extDet1, tmpS0, tmpS1;

	double a01 = -(Ax*Bx+Ay*By+Az*Bz);
	double b0 = (Cx*Ax+Cy*Ay+Cz*Az);
	double b1 = -(Cx*Bx+Cy*By+Cz*Bz);
	double c = Cx*Cx+Cy*Cy+Cz*Cz;
	double det = abs(1.0 - a01*a01);


    if (det >= EPS)
    {
        // Segments are not parallel.
        s0 = a01*b1 - b0;
        s1 = a01*b0 - b1;
        extDet0 = Extent0*det;
        extDet1 = Extent1*det;

        if (s0 >= -extDet0)
        {
            if (s0 <= extDet0)
            {
                if (s1 >= -extDet1)
                {
                    if (s1 <= extDet1)  // region 0 (interior)
                    {
                        // Minimum at interior points of segments.
                        double invDet = (1.0)/det;
                        s0 *= invDet;
                        s1 *= invDet;
                        sqrDist = s0*(s0 + a01*s1 + (2.0)*b0) +
                            s1*(a01*s0 + s1 + (2.0)*b1) + c;
                    }
                    else  // region 3 (side)
                    {
                        s1 = Extent1;
                        tmpS0 = -(a01*s1 + b0);
                        if (tmpS0 < -Extent0)
                        {
                            s0 = -Extent0;
                            sqrDist = s0*(s0 - (2.0)*tmpS0) +
                                s1*(s1 + (2.0)*b1) + c;
                        }
                        else if (tmpS0 <= Extent0)
                        {
                            s0 = tmpS0;
                            sqrDist = -s0*s0 + s1*(s1 + (2.0)*b1) + c;
                        }
                        else
                        {
                            s0 = Extent0;
                            sqrDist = s0*(s0 - (2.0)*tmpS0) +
                                s1*(s1 + (2.0)*b1) + c;
                        }
                    }
                }
                else  // region 7 (side)
                {
                    s1 = -Extent1;
                    tmpS0 = -(a01*s1 + b0);
                    if (tmpS0 < -Extent0)
                    {
                        s0 = -Extent0;
                        sqrDist = s0*(s0 - (2.0)*tmpS0) +
                            s1*(s1 + (2.0)*b1) + c;
                    }
                    else if (tmpS0 <= Extent0)
                    {
                        s0 = tmpS0;
                        sqrDist = -s0*s0 + s1*(s1 + (2.0)*b1) + c;
                    }
                    else
                    {
                        s0 = Extent0;
                        sqrDist = s0*(s0 - (2.0)*tmpS0) +
                            s1*(s1 + (2.0)*b1) + c;
                    }
                }
            }
            else
            {
                if (s1 >= -extDet1)
                {
                    if (s1 <= extDet1)  // region 1 (side)
                    {
                        s0 = Extent0;
                        tmpS1 = -(a01*s0 + b1);
                        if (tmpS1 < -Extent1)
                        {
                            s1 = -Extent1;
                            sqrDist = s1*(s1 - (2.0)*tmpS1) +
                                s0*(s0 + (2.0)*b0) + c;
                        }
                        else if (tmpS1 <= Extent1)
                        {
                            s1 = tmpS1;
                            sqrDist = -s1*s1 + s0*(s0 + (2.0)*b0) + c;
                        }
                        else
                        {
                            s1 = Extent1;
                            sqrDist = s1*(s1 - (2.0)*tmpS1) +
                                s0*(s0 + (2.0)*b0) + c;
                        }
                    }
                    else  // region 2 (corner)
                    {
                        s1 = Extent1;
                        tmpS0 = -(a01*s1 + b0);
                        if (tmpS0 < -Extent0)
                        {
                            s0 = -Extent0;
                            sqrDist = s0*(s0 - (2.0)*tmpS0) +
                                s1*(s1 + (2.0)*b1) + c;
                        }
                        else if (tmpS0 <= Extent0)
                        {
                            s0 = tmpS0;
                            sqrDist = -s0*s0 + s1*(s1 + (2.0)*b1) + c;
                        }
                        else
                        {
                            s0 = Extent0;
                            tmpS1 = -(a01*s0 + b1);
                            if (tmpS1 < -Extent1)
                            {
                                s1 = -Extent1;
                                sqrDist = s1*(s1 - (2.0)*tmpS1) +
                                    s0*(s0 + (2.0)*b0) + c;
                            }
                            else if (tmpS1 <= Extent1)
                            {
                                s1 = tmpS1;
                                sqrDist = -s1*s1 + s0*(s0 + (2.0)*b0) + c;
                            }
                            else
                            {
                                s1 = Extent1;
                                sqrDist = s1*(s1 - (2.0)*tmpS1) +
                                    s0*(s0 + (2.0)*b0) + c;
                            }
                        }
                    }
                }
                else  // region 8 (corner)
                {
                    s1 = -Extent1;
                    tmpS0 = -(a01*s1 + b0);
                    if (tmpS0 < -Extent0)
                    {
                        s0 = -Extent0;
                        sqrDist = s0*(s0 - (2.0)*tmpS0) +
                            s1*(s1 + (2.0)*b1) + c;
                    }
                    else if (tmpS0 <= Extent0)
                    {
                        s0 = tmpS0;
                        sqrDist = -s0*s0 + s1*(s1 + (2.0)*b1) + c;
                    }
                    else
                    {
                        s0 = Extent0;
                        tmpS1 = -(a01*s0 + b1);
                        if (tmpS1 > Extent1)
                        {
                            s1 = Extent1;
                            sqrDist = s1*(s1 - (2.0)*tmpS1) +
                                s0*(s0 + (2.0)*b0) + c;
                        }
                        else if (tmpS1 >= -Extent1)
                        {
                            s1 = tmpS1;
                            sqrDist = -s1*s1 + s0*(s0 + (2.0)*b0) + c;
                        }
                        else
                        {
                            s1 = -Extent1;
                            sqrDist = s1*(s1 - (2.0)*tmpS1) +
                                s0*(s0 + (2.0)*b0) + c;
                        }
                    }
                }
            }
        }
        else 
        {
            if (s1 >= -extDet1)
            {
                if (s1 <= extDet1)  // region 5 (side)
                {
                    s0 = -Extent0;
                    tmpS1 = -(a01*s0 + b1);
                    if (tmpS1 < -Extent1)
                    {
                        s1 = -Extent1;
                        sqrDist = s1*(s1 - (2.0)*tmpS1) +
                            s0*(s0 + (2.0)*b0) + c;
                    }
                    else if (tmpS1 <= Extent1)
                    {
                        s1 = tmpS1;
                        sqrDist = -s1*s1 + s0*(s0 + (2.0)*b0) + c;
                    }
                    else
                    {
                        s1 = Extent1;
                        sqrDist = s1*(s1 - (2.0)*tmpS1) +
                            s0*(s0 + (2.0)*b0) + c;
                    }
                }
                else  // region 4 (corner)
                {
                    s1 = Extent1;
                    tmpS0 = -(a01*s1 + b0);
                    if (tmpS0 > Extent0)
                    {
                        s0 = Extent0;
                        sqrDist = s0*(s0 - (2.0)*tmpS0) +
                            s1*(s1 + (2.0)*b1) + c;
                    }
                    else if (tmpS0 >= -Extent0)
                    {
                        s0 = tmpS0;
                        sqrDist = -s0*s0 + s1*(s1 + (2.0)*b1) + c;
                    }
                    else
                    {
                        s0 = -Extent0;
                        tmpS1 = -(a01*s0 + b1);
                        if (tmpS1 < -Extent1)
                        {
                            s1 = -Extent1;
                            sqrDist = s1*(s1 - (2.0)*tmpS1) +
                                s0*(s0 + (2.0)*b0) + c;
                        }
                        else if (tmpS1 <= Extent1)
                        {
                            s1 = tmpS1;
                            sqrDist = -s1*s1 + s0*(s0 + (2.0)*b0) + c;
                        }
                        else
                        {
                            s1 = Extent1;
                            sqrDist = s1*(s1 - (2.0)*tmpS1) +
                                s0*(s0 + (2.0)*b0) + c;
                        }
                    }
                }
            }
            else   // region 6 (corner)
            {
                s1 = -Extent1;
                tmpS0 = -(a01*s1 + b0);
                if (tmpS0 > Extent0)
                {
                    s0 = Extent0;
                    sqrDist = s0*(s0 - (2.0)*tmpS0) +
                        s1*(s1 + (2.0)*b1) + c;
                }
                else if (tmpS0 >= -Extent0)
                {
                    s0 = tmpS0;
                    sqrDist = -s0*s0 + s1*(s1 + (2.0)*b1) + c;
                }
                else
                {
                    s0 = -Extent0;
                    tmpS1 = -(a01*s0 + b1);
                    if (tmpS1 < -Extent1)
                    {
                        s1 = -Extent1;
                        sqrDist = s1*(s1 - (2.0)*tmpS1) +
                            s0*(s0 + (2.0)*b0) + c;
                    }
                    else if (tmpS1 <= Extent1)
                    {
                        s1 = tmpS1;
                        sqrDist = -s1*s1 + s0*(s0 + (2.0)*b0) + c;
                    }
                    else
                    {
                        s1 = Extent1;
                        sqrDist = s1*(s1 - (2.0)*tmpS1) +
                            s0*(s0 + (2.0)*b0) + c;
                    }
                }
            }
        }
    }
    else
    {
        // The segments are parallel.  The average b0 term is designed to
        // ensure symmetry of the function.  That is, dist(seg0,seg1) and
        // dist(seg1,seg0) should produce the same number.
        double e0pe1 = Extent0 + Extent1;
        double sign = (a01 > 0.0 ? -1.0 : 1.0);
        double b0Avr = ((double)0.5)*(b0 - sign*b1);
        double lambda = -b0Avr;
        if (lambda < -e0pe1)
        {
            lambda = -e0pe1;
        }
        else if (lambda > e0pe1)
        {
            lambda = e0pe1;
        }

        s1 = -sign*lambda*Extent1/e0pe1;
        s0 = lambda + sign*s1;
        sqrDist = lambda*(lambda + (2.0)*b0Avr) + c;
    }

    //mClosestPoint0 = mSegment0->Center + s0*mSegment0->Direction;
    //mClosestPoint1 = mSegment1->Center + s1*mSegment1->Direction;
    //mSegment0Parameter = s0;
    //mSegment1Parameter = s1;

    // Account for numerical round-off errors.
	return sqrDist < 0 ? 0 : sqrDist;
}




void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
	if (nlhs != 2 || nrhs != 2) {
		mexErrMsgTxt("Usage: [afDistance, aiIndexMin] = fndllLineLineDist(Pa [3xN], Pb [3xN])");
		return;
	} 

	const int *dim1 = mxGetDimensions(prhs[0]);
	int NumA = dim1[1];

	const int *dim2 = mxGetDimensions(prhs[1]);
	int NumB = dim2[1];

	if (dim1[0] != 3 || dim2[0] != 3 || NumA != NumB) {
		mexErrMsgTxt("Usage: [afDistance, aiIndexMin] = fndllLineLineDist(Pa [3xN], Pb [3xN])");
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
/*
		double x1 = Pa[3*i+0];
		double y1 = Pa[3*i+1];
		double z1 = Pa[3*i+2];

		double x2 = Pb[3*i+0];
		double y2 = Pb[3*i+1];
		double z2 = Pb[3*i+2];


		double Ax = x2-x1;
		double Ay = y2-y1;
		double Az = z2-z1;
*/
		double M = 1e20;
		int iMinInd = 0;
		for (int j =0; j<NumB;j++) {
			if (i==j) continue;
			/*
			double x3 = Pa[3*j+0];
			double y3 = Pa[3*j+1];
			double z3 = Pa[3*j+2];

			double x4 = Pb[3*j+0];
			double y4 = Pb[3*j+1];
			double z4 = Pb[3*j+2];

		double Bx = x4-x3;
		double By = y4-y3;
		double Bz = z4-z3;

		double Cx = x3-x1;
		double Cy = y3-y1;
		double Cz = z3-z1;


		double AxBx = Ay*Bz-Az*By;
		double AxBy = Az*Bx-Ax*Bz;
		double AxBz = Ax*By-Ay*Bx;      

		double AxBn = sqrt(AxBx*AxBx+AxBy*AxBy+AxBz*AxBz);

		

		double D = (AxBn < EPS) ? sqrt(Cx*Cx+Cy*Cy+Cz*Cz) : (abs(Cx * AxBx + Cy * AxBy + Cz * AxBz) / AxBn);
		
				
// given, [x1,x2], [x3,x4], the distance between the lines is given by:
// D = | dot(c, A x B) |  / |A x B|
// where:
// A = x2-x1
// B = x4-x3
// C = x3-x1

*/
			double D = GetSegmentDistance(Pa,Pb,i,j);

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
