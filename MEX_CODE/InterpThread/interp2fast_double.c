#include "mex.h"
#include "math.h"
#include "image_interpolation.h"
#include "multiple_os_thread.h"

voidthread getgrayvalue(double **Args) {
    double *Iin, *Vout, *Xi, *Yi;
    double *Nthreadsd;
    int Nthreads;
	
    double  *moded;
	int mode=0;
     int i;
    
	/* Output image size */
    double *VoutSize_d;
    int VoutSize[3];
	   
    /* Cubic and outside black booleans */
    bool black, cubic;
     
    /* Size of input image */
    int Isize[3]={0,0};
    double *Isize_d;
        
    /* offset */
    int offset=0;
    
    /* The thread ID number/name */
    double *ThreadID;
    
    Iin=Args[0];
    Vout=Args[1];
    Xi=Args[2];
    Yi=Args[3];
    Isize_d=Args[4];
    VoutSize_d=Args[5];
    ThreadID=Args[6];
	moded=Args[7]; mode=(int) moded[0];
    Nthreadsd=Args[8];  Nthreads=(int)Nthreadsd[0];
    
	if(mode==0||mode==2){ black = false; } else { black = true; }
    if(mode==0||mode==1){ cubic = false; } else { cubic = true; }

    Isize[0]=(int)Isize_d[0];
    Isize[1]=(int)Isize_d[1];
    Isize[2]=(int)Isize_d[2];
    
    VoutSize[0]=(int)VoutSize_d[0];
    VoutSize[1]=(int)VoutSize_d[1];
    
    offset=(int) ThreadID[0];
	
    /*  Loop through all image pixel coordinates */
    for (i=offset; i<VoutSize[0]; i=i+Nthreads)
    {
        Vout[i]=interpolate_2d_double_gray(Xi[i]-1.0, Yi[i]-1.0, Isize, Iin,cubic,black); 
    }

    /*  explicit end thread, helps to ensure proper recovery of resources allocated for the thread */
	EndThread;
}


/* The matlab mex function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
    /* I is the input image, Iout the transformed image  */
    /* Tx and Ty images of the translation of every pixel. */
    double *Iin, *Vout, *Xi, *Yi;
	double *moded;
	double Nthreadsd[1];
    int Nthreads;
    
    /* double pointer array to store all needed function variables) */
    double ***ThreadArgs;
    double **ThreadArgs1;
    
	/* Handles to the worker threads */
	ThreadHANDLE *ThreadList;
    
    /* ID of Threads */
    double **ThreadID;              
    double *ThreadID1;

    /* Size of input image */
    const mwSize *dims;
    double Isize_d[2]={0,0};
    int Isize[2]={1,1};
    
    /* Size of output */
    double VoutSize_d[3]={1,1};
    int VoutSize[3]={1,1};
	
	/* Loop variable  */
	int i;
	
    /* Check for proper number of arguments. */
    if(nrhs<4) {
      mexErrMsgTxt("Four inputs are required.");
    } else if(nlhs!=1) {
      mexErrMsgTxt("One output required");
    }
 
    /* Get the sizes of the image */
    dims = mxGetDimensions(prhs[0]);   
    Isize_d[0] = (double)dims[0]; 
    Isize_d[1] = (double)dims[1]; 
    Isize[0]=(int)Isize_d[0];
    Isize[1]=(int)Isize_d[1];
       
    /* Set the sizes of the output */
    VoutSize[0]=(int)mxGetNumberOfElements(prhs[1]);
    VoutSize_d[0]=VoutSize[0];
            
    /* J= interp2(I,xi,yi,'linear') */

    /* Assign pointers to each input. */
    Iin=mxGetPr(prhs[0]);
    Xi=mxGetPr(prhs[1]);
    Yi=mxGetPr(prhs[2]);
	moded=mxGetPr(prhs[3]);
        
    /* Create image matrix for the return arguments   */  
    plhs[0] = mxCreateNumericArray(2, VoutSize, mxDOUBLE_CLASS, mxREAL);

    /* Assign pointer to output. */
    Vout = mxGetPr(plhs[0]);
        
    Nthreadsd[0]=(double)getNumCores();
    Nthreads=(int)Nthreadsd[0];
    
    /* Reserve room for handles of threads in ThreadList  */
    ThreadList = (ThreadHANDLE*)malloc(Nthreads* sizeof( ThreadHANDLE ));
    ThreadID = (double **)malloc( Nthreads* sizeof(double *) );
    ThreadArgs = (double ***)malloc( Nthreads* sizeof(double **) );


      for (i=0; i<Nthreads; i++)
      {
        /*  Make Thread ID  */
        ThreadID1= (double *)malloc( 1* sizeof(double) );
        ThreadID1[0]=i;
        ThreadID[i]=ThreadID1;  

        /*  Make Thread Structure  */
        ThreadArgs1 = (double **)malloc( 9* sizeof( double * ) );  
        ThreadArgs1[0]=Iin;
        ThreadArgs1[1]=Vout;
        ThreadArgs1[2]=Xi;
        ThreadArgs1[3]=Yi;
        ThreadArgs1[4]=Isize_d;
        ThreadArgs1[5]=VoutSize_d;
        ThreadArgs1[6]=ThreadID[i];
        ThreadArgs1[7]=moded;
        ThreadArgs1[8]=Nthreadsd;

        ThreadArgs[i]=ThreadArgs1;
        StartThread(ThreadList[i], &getgrayvalue, ThreadArgs[i])
      }

      for (i=0; i<Nthreads; i++) { WaitForThreadFinish(ThreadList[i]); }

      for (i=0; i<Nthreads; i++) 
      { 
        free(ThreadArgs[i]);
        free(ThreadID[i]);
      }

      free(ThreadArgs);
      free(ThreadID );
      free(ThreadList);

}
        

