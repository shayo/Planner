#include "mex.h"
#include "math.h"
#include "image_interpolation.h"
#include "multiple_os_thread.h"

voidthread getgrayvalue(float **Args) {
    float *Iin, *Vout, *Xi, *Yi, *Zi;
    float *Nthreadsd;
    int Nthreads;
	
    float  *moded;
	int mode=0;
     int i;
    
	/* Output image size */
    float *VoutSize_d;
    int VoutSize[3];
	   
    /* Cubic and outside black booleans */
    bool black, cubic;
     
    /* Size of input image */
    int Isize[3]={0,0,0};
    float *Isize_d;
        
    /* offset */
    int offset=0;
    
    /* The thread ID number/name */
    float *ThreadID;
    
    Iin=Args[0];
    Vout=Args[1];
    Xi=Args[2];
    Yi=Args[3];
	Zi=Args[4];
	Isize_d=Args[5];
    VoutSize_d=Args[6];
    ThreadID=Args[7];
	moded=Args[8]; mode=(int) moded[0];
    Nthreadsd=Args[9];  Nthreads=(int)Nthreadsd[0];
    
	if(mode==0||mode==2){ black = false; } else { black = true; }
    if(mode==0||mode==1){ cubic = false; } else { cubic = true; }
    black = true;
    Isize[0]=(int)Isize_d[0];
    Isize[1]=(int)Isize_d[1];
    Isize[2]=(int)Isize_d[2];
    
    VoutSize[0]=(int)VoutSize_d[0];
    VoutSize[1]=(int)VoutSize_d[1];
    
    offset=(int) ThreadID[0];
	
    /*  Loop through all image pixel coordinates */
    for (i=offset; i<VoutSize[0]; i=i+Nthreads)
    {
        Vout[i]=interpolate_3d_float_gray(Xi[i]-1.0f, Yi[i]-1.0f, Zi[i]-1.0f, Isize, Iin,cubic,black); 
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
    float *Iin, *Vout, *Xi, *Yi, *Zi;
	float *moded;
    double Nthreadsd[1];
	float Nthreadsf[1];	
    int Nthreads;
    
    /* float pointer array to store all needed function variables) */
    float ***ThreadArgs;
    float **ThreadArgs1;
    
	/* Handles to the worker threads */
	ThreadHANDLE *ThreadList;
    
    /* ID of Threads */
    float **ThreadID;              
    float *ThreadID1;

    /* Size of input image */
    const mwSize *dims;
    float Isize_d[3]={0,0,0};
    int Isize[3]={1,1,1};
    
    /* Size of output */
    float VoutSize_d[3]={1,1};
    int VoutSize[3]={1,1};
	
	/* Loop variable  */
	int i;
	
    /* Check for proper number of arguments. */
    if(nrhs<5) {
      mexErrMsgTxt("Five inputs are required.");
    } else if(nlhs!=1) {
      mexErrMsgTxt("One output required");
    }
 
    /* Get the sizes of the image */
    dims = mxGetDimensions(prhs[0]);   
    Isize_d[0] = (float)dims[0]; 
    Isize_d[1] = (float)dims[1]; 
    Isize_d[2] = (float)dims[2]; 
    
    Isize[0]=(int)Isize_d[0];
    Isize[1]=(int)Isize_d[1];
    Isize[2]=(int)Isize_d[2];   
    /* Set the sizes of the output */
    VoutSize[0]=(int)mxGetNumberOfElements(prhs[1]);
    VoutSize_d[0]=(float)VoutSize[0];
            
    /* J= interp2(I,xi,yi,'linear') */

    /* Assign pointers to each input. */
    Iin=(float *)mxGetData(prhs[0]);
    Xi=(float *)mxGetData(prhs[1]);
    Yi=(float *)mxGetData(prhs[2]);
	Zi=(float *)mxGetData(prhs[3]);
	moded=(float *)mxGetData(prhs[4]);
        
    /* Create image matrix for the return arguments   */  
    plhs[0] = mxCreateNumericArray(2, VoutSize, mxSINGLE_CLASS, mxREAL);

    /* Assign pointer to output. */
    Vout = (float *)mxGetData(plhs[0]);
        
	/* Get number of allowed threads */
	Nthreadsd[0]=(double)getNumCores(); Nthreadsf[0]=(float)Nthreadsd[0];
	Nthreads=(int)Nthreadsd[0];
    
    /* Reserve room for handles of threads in ThreadList  */
    ThreadList = (ThreadHANDLE*)malloc(Nthreads* sizeof( ThreadHANDLE ));
    ThreadID = (float **)malloc( Nthreads* sizeof(float *) );
    ThreadArgs = (float ***)malloc( Nthreads* sizeof(float **) );


      for (i=0; i<Nthreads; i++)
      {
        /*  Make Thread ID  */
        ThreadID1= (float *)malloc( 1* sizeof(float) );
        ThreadID1[0]=(float)i;
        ThreadID[i]=ThreadID1;  

        /*  Make Thread Structure  */
        ThreadArgs1 = (float **)malloc( 10* sizeof( float * ) );  
        ThreadArgs1[0]=Iin;
        ThreadArgs1[1]=Vout;
        ThreadArgs1[2]=Xi;
        ThreadArgs1[3]=Yi;
		ThreadArgs1[4]=Zi;
		ThreadArgs1[5]=Isize_d;
        ThreadArgs1[6]=VoutSize_d;
        ThreadArgs1[7]=ThreadID[i];
        ThreadArgs1[8]=moded;
        ThreadArgs1[9]=Nthreadsf;

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
        

