#include <stdio.h>
#include <math.h>
#include "mex.h"
#define fEps 1e-8


class Point3D {
public:
	Point3D();
	Point3D(double _x, double _y, double _z);
	Point3D& operator+=(const Point3D &p);
	Point3D operator*(const Point3D &p) const;
	Point3D operator*(double s) const;
	Point3D operator=(const Point3D &p) ;
	Point3D operator/(const Point3D &p) const;
	friend Point3D operator* (double f, const Point3D& p)
	{ return Point3D(p.x*f,p.y*f,p.z*f);}

	Point3D operator-() const;


	Point3D& operator/=(double s);
	Point3D operator+(const Point3D&p) const;
	Point3D operator-(const Point3D&p) const;
	double x,y,z;


};


Point3D Point3D::operator-() const {
	return Point3D(-x,-y,-z);
}

Point3D::Point3D() {
	x=y=z=0;
}

Point3D& Point3D::operator/=(double s) {
	x /= s;
	y /= s;
	z /= s;
	return *this;
}

Point3D& Point3D::operator+=(const Point3D &p) {
	x += p.x;
	y += p.y;
	return *this;
}

Point3D Point3D::operator=(const Point3D &p) {
	x=p.x;
	y=p.y;
	z=p.z;
	return *this;
}
Point3D Point3D::operator+(const Point3D&p) const { 
	return Point3D(x + p.x, y+p.y, z+p.z);
}

Point3D Point3D::operator-(const Point3D&p) const { 
	return Point3D(x - p.x, y -p.y, z -p.z);
}

Point3D Point3D::operator*(const Point3D&p) const { 
	return Point3D(x * p.x, y*p.y, z*p.z);
}

Point3D Point3D::operator*(double s) const { 
	return Point3D(x * s, y*s, z*s);
}


Point3D Point3D::operator/(const Point3D&p) const { 
	return Point3D(x / p.x, y/p.y, z/p.z);
}

Point3D::Point3D(double _x, double _y, double _z) {
x=_x;
y=_y;
z=_z;
}

const int IT_EMPTY = 0;
const int IT_SEGMENT = 1;
const int IT_POINT = 2;
const int IT_POLYGON = 3;

int TrianglePlaneIntersection(double *afSD, const Point3D &rkV0, const Point3D &rkV1, const Point3D &rkV2, Point3D* m_akPoint) 
{
	int m_iIntersectionType;
	double fZero = 0.0;
//	Point3D m_akPoint[3];
	int m_iQuantity;

	if (afSD[0] > fZero)
	{
		if (afSD[1] > fZero)
		{
			if (afSD[2] > fZero)
			{
				// ppp
				m_iQuantity = 0;
				m_iIntersectionType = IT_EMPTY;
			}
			else if (afSD[2] < fZero)
			{
				// ppm
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[2]))*(rkV2-rkV0);
				m_akPoint[1] = rkV1+(afSD[1]/(afSD[1]-afSD[2]))*(rkV2-rkV1);
				m_iIntersectionType = IT_SEGMENT;
			}
			else
			{
				// ppz
				m_iQuantity = 1;
				m_akPoint[0] = rkV2;
				m_iIntersectionType = IT_POINT;
			}
		}
		else if (afSD[1] < fZero)
		{
			if (afSD[2] > fZero)
			{
				// pmp
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[1]))*(rkV1-rkV0);
				m_akPoint[1] = rkV1+(afSD[1]/(afSD[1]-afSD[2]))*(rkV2-rkV1);
				m_iIntersectionType = IT_SEGMENT;
			}
			else if (afSD[2] < fZero)
			{
				// pmm
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[1]))*(rkV1-rkV0);
				m_akPoint[1] = rkV0+(afSD[0]/(afSD[0]-afSD[2]))*(rkV2-rkV0);
				m_iIntersectionType = IT_SEGMENT;
			}
			else
			{
				// pmz
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[1]))*(rkV1-rkV0);
				m_akPoint[1] = rkV2;
				m_iIntersectionType = IT_SEGMENT;
			}
		}
		else
		{
			if (afSD[2] > fZero)
			{
				// pzp
				m_iQuantity = 1;
				m_akPoint[0] = rkV1;
				m_iIntersectionType = IT_POINT;
			}
			else if (afSD[2] < fZero)
			{
				// pzm
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[2]))*(rkV2-rkV0);
				m_akPoint[1] = rkV1;
				m_iIntersectionType = IT_SEGMENT;
			}
			else
			{
				// pzz
				m_iQuantity = 2;
				m_akPoint[0] = rkV1;
				m_akPoint[1] = rkV2;
				m_iIntersectionType = IT_SEGMENT;
			}
		}
	}
	else if (afSD[0] < fZero)
	{
		if (afSD[1] > fZero)
		{
			if (afSD[2] > fZero)
			{
				// mpp
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[1]))*(rkV1-rkV0);
				m_akPoint[1] = rkV0+(afSD[0]/(afSD[0]-afSD[2]))*(rkV2-rkV0);
				m_iIntersectionType = IT_SEGMENT;
			}
			else if (afSD[2] < fZero)
			{
				// mpm
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[1]))*(rkV1-rkV0);
				m_akPoint[1] = rkV1+(afSD[1]/(afSD[1]-afSD[2]))*(rkV2-rkV1);
				m_iIntersectionType = IT_SEGMENT;
			}
			else
			{
				// mpz
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[1]))*(rkV1-rkV0);
				m_akPoint[1] = rkV2;
				m_iIntersectionType = IT_SEGMENT;
			}
		}
		else if (afSD[1] < fZero)
		{
			if (afSD[2] > fZero)
			{
				// mmp
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[2]))*(rkV2-rkV0);
				m_akPoint[1] = rkV1+(afSD[1]/(afSD[1]-afSD[2]))*(rkV2-rkV1);
				m_iIntersectionType = IT_SEGMENT;
			}
			else if (afSD[2] < fZero)
			{
				// mmm
				m_iQuantity = 0;
				m_iIntersectionType = IT_EMPTY;
			}
			else
			{
				// mmz
				m_iQuantity = 1;
				m_akPoint[0] = rkV2; // m_pkTriangle->V[2]; ?!?!?!?
				m_iIntersectionType = IT_POINT;
			}
		}
		else
		{
			if (afSD[2] > fZero)
			{
				// mzp
				m_iQuantity = 2;
				m_akPoint[0] = rkV0+(afSD[0]/(afSD[0]-afSD[2]))*(rkV2-rkV0);
				m_akPoint[1] = rkV1;
				m_iIntersectionType = IT_SEGMENT;
			}
			else if (afSD[2] < fZero)
			{
				// mzm
				m_iQuantity = 1;
				m_akPoint[0] = rkV1;
				m_iIntersectionType = IT_POINT;
			}
			else
			{
				// mzz
				m_iQuantity = 2;
				m_akPoint[0] = rkV1;
				m_akPoint[1] = rkV2;
				m_iIntersectionType = IT_SEGMENT;
			}
		}
	}
	else
	{
		if (afSD[1] > fZero)
		{
			if (afSD[2] > fZero)
			{
				// zpp
				m_iQuantity = 1;
				m_akPoint[0] = rkV0;
				m_iIntersectionType = IT_POINT;
			}
			else if (afSD[2] < fZero)
			{
				// zpm
				m_iQuantity = 2;
				m_akPoint[0] = rkV1+(afSD[1]/(afSD[1]-afSD[2]))*(rkV2-rkV1);
				m_akPoint[1] = rkV0;
				m_iIntersectionType = IT_SEGMENT;
			}
			else
			{
				// zpz
				m_iQuantity = 2;
				m_akPoint[0] = rkV0;
				m_akPoint[1] = rkV2;
				m_iIntersectionType = IT_SEGMENT;
			}
		}
		else if (afSD[1] < fZero)
		{
			if (afSD[2] > fZero)
			{
				// zmp
				m_iQuantity = 2;
				m_akPoint[0] = rkV1+(afSD[1]/(afSD[1]-afSD[2]))*(rkV2-rkV1);
				m_akPoint[1] = rkV0;
				m_iIntersectionType = IT_SEGMENT;
			}
			else if (afSD[2] < fZero)
			{
				// zmm
				m_iQuantity = 1;
				m_akPoint[0] = rkV0;
				m_iIntersectionType = IT_POINT;
			}
			else
			{
				// zmz
				m_iQuantity = 2;
				m_akPoint[0] = rkV0;
				m_akPoint[1] = rkV2;
				m_iIntersectionType = IT_SEGMENT;
			}
		}
		else
		{
			if (afSD[2] > fZero)
			{
				// zzp
				m_iQuantity = 2;
				m_akPoint[0] = rkV0;
				m_akPoint[1] = rkV1;
				m_iIntersectionType = IT_SEGMENT;
			}
			else if (afSD[2] < fZero)
			{
				// zzm
				m_iQuantity = 2;
				m_akPoint[0] = rkV0;
				m_akPoint[1] = rkV1;
				m_iIntersectionType = IT_SEGMENT;
			}
			else
			{
				// zzz
				m_iQuantity = 3;
				m_akPoint[0] = rkV0;
				m_akPoint[1] = rkV1;
				m_akPoint[2] = rkV2;
				m_iIntersectionType = IT_POLYGON;
			}
		}
	}

	return m_iIntersectionType ;
}

bool bIntersect(double *afPlane, double *vertices, int *face, double *afSD)
{
// face is a list of three indices (representing triangle's vertices)

for (int i=0;i<3;i++) {
    afSD[i] = afPlane[0] * vertices[3*face[i]+0] + 
			  afPlane[1] * vertices[3*face[i]+1] + 
			  afPlane[2] * vertices[3*face[i]+2] + afPlane[3] ; // assuming afPlane(1:3) is unit length
	afSD[i] = fabs(afSD[i]) < fEps ? 0 : afSD[i];
}
// The triangle intersects the plane if not all vertices are on the
// positive side of the plane and not all vertices are on the negative
// side of the plane.
double fZero = 0;
return  !(afSD[0] > fZero && afSD[1] > fZero && afSD[2] > fZero) 
           && !(afSD[0] < fZero && afSD[1] < fZero && afSD[2] < fZero);
}

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
	if (nlhs < 1 || nrhs !=3) {
		mexErrMsgTxt("Usage: [a2fLines, aiFaces] = fndllMeshPlaneIntersect(afPlane, apt3fVertices, a2iFaces)");
		return;
	}

	double* plane = (double *)mxGetData(prhs[0]);
	double* vertices = (double *)mxGetData(prhs[1]);
	double* faces = (double *)mxGetData(prhs[2]);

	

	const int *facesdim = mxGetDimensions(prhs[2]);
	//assert(facesdim[0] == 3);
	int iNumFaces = facesdim[1];

	double afSD[3];
	int face[3];

	double fPlaneNorm = sqrt(plane[0]*plane[0]+plane[1]*plane[1]+plane[2]*plane[2]);
	if (fabs(fPlaneNorm -1) > 1e-5) {
		// normalize plane 
		plane[0] /= fPlaneNorm;
		plane[1] /= fPlaneNorm;
		plane[2] /= fPlaneNorm;
		plane[3] /= fPlaneNorm;
	}


	int iMaxLines = iNumFaces * 3;

	int *SourceTriangle = new int[iMaxLines];

	Point3D *aptStart = new Point3D[iMaxLines];
	Point3D *aptEnd = new Point3D[iMaxLines];
	int iNumLines = 0;

	for (int iFaceIter=0;iFaceIter<iNumFaces;iFaceIter++) {

		// Test for intersection
		face[0]  = faces[3*iFaceIter+0]-1;
		face[1]  = faces[3*iFaceIter+1]-1;
		face[2]  = faces[3*iFaceIter+2]-1;
		
		Point3D rkV0( vertices[3*face[0]+0], vertices[3*face[0]+1], vertices[3*face[0]+2]);
		Point3D rkV1( vertices[3*face[1]+0], vertices[3*face[1]+1], vertices[3*face[1]+2]);
		Point3D rkV2( vertices[3*face[2]+0], vertices[3*face[2]+1], vertices[3*face[2]+2]);

		Point3D m_akPoint[3];
		if (bIntersect(plane, vertices, face, afSD)) {
			int iType = TrianglePlaneIntersection(afSD, rkV0,  rkV1, rkV2,m_akPoint );

			switch (iType) {
				case IT_EMPTY:
					break;
				case IT_SEGMENT:
					SourceTriangle[iNumLines] = iFaceIter+1;
					aptStart[iNumLines] = m_akPoint[0];
					aptEnd[iNumLines] = m_akPoint[1];
					iNumLines++;

					break;
				case IT_POINT:
					break;
				case IT_POLYGON:
					SourceTriangle[iNumLines] = iFaceIter+1;
					aptStart[iNumLines] = m_akPoint[0];
					aptEnd[iNumLines] = m_akPoint[1];
					iNumLines++;
					SourceTriangle[iNumLines] = iFaceIter+1;
					aptStart[iNumLines] = m_akPoint[0];
					aptEnd[iNumLines] = m_akPoint[2];
					iNumLines++;
					SourceTriangle[iNumLines] = iFaceIter+1;
					aptStart[iNumLines] = m_akPoint[1];
					aptEnd[iNumLines] = m_akPoint[2];
					iNumLines++;
					break;
			}

		}
	}


	int output_dim_array[2];
	output_dim_array[0] = 6;
	output_dim_array[1] = iNumLines;
	plhs[0] = mxCreateNumericArray(2, output_dim_array, mxDOUBLE_CLASS, mxREAL);
	
	double *oup = (double*)mxGetPr(plhs[0]);
	for (int iLineIter=0;iLineIter <iNumLines;  iLineIter++) {
		oup[iLineIter*6 + 0] = aptStart[iLineIter].x;
		oup[iLineIter*6 + 1] = aptStart[iLineIter].y;
		oup[iLineIter*6 + 2] = aptStart[iLineIter].z;
		oup[iLineIter*6 + 3] = aptEnd[iLineIter].x;
		oup[iLineIter*6 + 4] = aptEnd[iLineIter].y;
		oup[iLineIter*6 + 5] = aptEnd[iLineIter].z;
	}
	
	if (nlhs > 1) {
		output_dim_array[0] = 1;
		output_dim_array[1] = iNumLines;
		plhs[1] = mxCreateNumericArray(2, output_dim_array, mxDOUBLE_CLASS, mxREAL);
		oup = (double*)mxGetPr(plhs[1]);
		for (int iLineIter=0;iLineIter <iNumLines;  iLineIter++) {
			oup[iLineIter] = (double)SourceTriangle[iLineIter];
		}
	}

	delete [] SourceTriangle;
	delete [] aptStart; 
	delete [] aptEnd; 

}
