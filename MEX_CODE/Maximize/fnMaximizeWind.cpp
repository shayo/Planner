// Based on Alain Trostel's code.

#include <windows.h>
#include "mex.h"

/* interface between MATLAB and the C function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	/* declare variables */
	HWND hWnd;
	long nStyle;
	int strLength;
	char *windowname, *resizeState;

	/* length of the string */
	strLength = mxGetN(prhs[0])+1;
	/* allocate memory for the window name */
	/* MATLAB frees the allocated memory automatically */
	windowname = new char[strLength];
	/* copy the variable from MATLAB */
	mxGetString(prhs[0],windowname,strLength);

	/* length of the string */
	strLength = mxGetN(prhs[1])+1;
	/* allocate memory for the resize state */
	/* MATLAB frees the allocated memory automatically */
	resizeState = new char[strLength];
	/* copy the variable from MATLAB */
	mxGetString(prhs[1],resizeState,strLength);


	/* handle of the window */
	hWnd = FindWindow(NULL,windowname);

	/* get current window style */
	nStyle = GetWindowLong(hWnd,GWL_STYLE);

	/* make sure that the window can be resized */
	SetWindowLong(hWnd,GWL_STYLE,nStyle | WS_MAXIMIZEBOX);

	/* maximize window */
	ShowWindow(hWnd,SW_MAXIMIZE);

	/* window is not resizable */
	if(strcmp(resizeState,"off") == 0)
	{
		/* restore the settings */
		SetWindowLong(hWnd,GWL_STYLE,nStyle);
	}

	/* redraw the menu bar */
	DrawMenuBar(hWnd);
	delete [] windowname;
	delete [] resizeState;
}
