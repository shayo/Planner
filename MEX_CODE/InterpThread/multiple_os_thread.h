/*   undef needed for LCC compiler  */
#undef EXTERN_C
#ifdef _WIN32
 #include <windows.h>
 #include <process.h>
 #define voidthread unsigned __stdcall
 #define EndThread _endthreadex(0); return 0
 #define ThreadHANDLE HANDLE
 #define WaitForThreadFinish(t) WaitForSingleObject(t, INFINITE);CloseHandle(t)
 #define StartThread(a,b,c) a=(HANDLE)_beginthreadex(NULL, 0, b, c, 0, NULL );
#else
 #ifdef MACOS
  #include <sys/param.h>
  #include <sys/sysctl.h>
 #else
  #include <unistd.h> 
 #endif
 #include <pthread.h>
 #define voidthread void
 #define EndThread pthread_exit(NULL)
 #define ThreadHANDLE pthread_t
 #define WaitForThreadFinish(t) pthread_join(t, NULL)
 #define StartThread(a,b,c) pthread_create((pthread_t*)&a, NULL, (void*)b, c);
#endif

int getNumCores() {
#ifdef WIN32
    SYSTEM_INFO sysinfo;
    GetSystemInfo(&sysinfo);
    return sysinfo.dwNumberOfProcessors;
#elif MACOS
    int nm[2];
    size_t len = 4;
    uint32_t count;
    nm[0] = CTL_HW; nm[1] = HW_AVAILCPU;
    sysctl(nm, 2, &count, &len, NULL, 0);
    if(count < 1) {
        nm[1] = HW_NCPU;
        sysctl(nm, 2, &count, &len, NULL, 0);
        if(count < 1) { count = 1; }
    }
    return count;
#else
    return sysconf(_SC_NPROCESSORS_ONLN);
#endif
}



