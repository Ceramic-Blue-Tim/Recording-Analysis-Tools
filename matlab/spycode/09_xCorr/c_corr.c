/*
 c_xy = c_corr(sp_x, sp_y, bin_s, win_s);

 MEX file to compute the basis for cross-correlation. The function counts
 the spikes in train sp_y surrounding all spikes in sp_x. sp_x and sp_y
 should be column vectors. bin_s must be odd, so that the spike in sp_x
 can actually serve as the center around which to compute the cross-
 correlation.
 win_s should be a solution to win_s = n_bin * bin_s + (bin_s - 1)/2, with
 n_bin a natural number (it is computed internally). There are checks on
 this in the method, throwing a MatLab warning, and resetting the value to
 a close-by value.
 
 PL Baljon, NBT, DIBE, University of Genova
 v1.0, 07/01/08
 
 */
#include "mex.h"

void mexFunction(int nhls, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    double *bin_s_d, *win_s_d, *n_bin_d, *sp_x, *sp_y, *c_xy;
    int  n_x, n_y, win_s, bin_s, n_bin;
    
    sp_x  = mxGetPr(prhs[0]);
    n_x   = mxGetM(prhs[0]);
    sp_y  = mxGetPr(prhs[1]);
    n_y   = mxGetM(prhs[1]);
    bin_s_d = mxGetPr(prhs[2]);
    win_s_d = mxGetPr(prhs[3]);
    // n_bin_d = mxGetPr(prhs[4]);//(int)(win_s - (&bin_s-1)/2) / &bin_s); // 40

    win_s = (int)(*win_s_d);
    bin_s = (int)(*bin_s_d);
    n_bin = (int)((win_s - (bin_s-1)/2.0) / bin_s);
    
    plhs[0] = mxCreateDoubleMatrix(n_bin * 2 + 1,1,mxREAL);
    c_xy = mxGetPr(plhs[0]);
    //printf("n_x: %d, n_y: %d, bin_s: %d, win_s: %d, n_bin: %d\n",n_x,n_y,bin_s,win_s,n_bin);
    
    if(mxGetN(prhs[0]) > 1)
        mexWarnMsgIdAndTxt("c_corri:InputSizeWarning", "input spike train x should be n_spikes x 1 matrices. dim 2 = %d > 1.",mxGetN(prhs[0]));
    if(mxGetN(prhs[1]) > 1)
        mexWarnMsgIdAndTxt("c_corri:InputSizeWarning", "input spike train y should be n_spikes x 1 matrices. dim 2 = %d > 1.",mxGetN(prhs[1]));
    
    if(bin_s%2 == 0){
        bin_s++;
        mexWarnMsgIdAndTxt("c_corri:EvenBinSize", "bin_s must be odd. reset bin_s: %d -> %d.",bin_s-1,bin_s);
    }
    if((win_s - (int)((double)(bin_s-1)/2.0))%bin_s != 0){
        win_s = (int)((bin_s - 1.0)/2.0) + n_bin * bin_s;
        mexWarnMsgIdAndTxt("c_corri:ParamsDontCorrespond", "bins must fit the window. reset win_s:%d, bin_s:%d, n_bin:%d.",win_s,bin_s,n_bin);
    }
    
    c_corr(n_x, sp_x, n_y, sp_y, bin_s, win_s, n_bin, c_xy);
}

void c_corr(int n_x, double sp_x[], int n_y, double sp_y[], int bin_s, int win_s, int n_bin, double c_xy[]){
    bool debug = false;
    int ix, iy, ib, l_bnd, u_bnd;
    /* Initialize the cross-correlation. */
    for(ib = 0; ib < 2 * n_bin + 1; ib++)
        c_xy[ib] = 0.0;
    
    for(ix = 0, iy = 0; ix < n_x; ix++){
        if(debug) printf("spike %d (%2.1f).\n",ix, sp_x[ix]);
        /* Go back to the last spike before the first bin */
        while(iy > 0 && sp_y[iy] >= sp_x[ix] - (double)win_s){
            iy--;
        }

        if(debug) printf("\tstart iy = %d (%2.1f).\n",iy,sp_y[iy]);
        /* Do for each bin */ 
        for(ib = 0; ib < 2 * n_bin + 1; ib++){
            /* Compute the beginning of this and the next bin*/
            l_bnd = (int)(sp_x[ix]) + (ib * bin_s) - win_s;
            u_bnd = (int)(sp_x[ix]) - win_s + ((ib+1) * bin_s);
            /* Go to the first spike in this bin. It might skip to the next 
               bin if this one is empty. The lower bound is part of the bin. */
            while(iy < n_y && sp_y[iy] < l_bnd)
                iy++;
            
            if(debug) printf("\t\tib: %d [%d ... %d]. first iy = %d (%2.1f).\n",ib,l_bnd,u_bnd,iy,sp_y[iy]);
            /* For each spike (strictly) smaller than the upper bound increment
               the cross-correlation and go to the next spike. */
            while(iy < n_y && sp_y[iy] < u_bnd){
                c_xy[ib] = c_xy[ib] + 1;
                iy++;
                if(debug) printf("\t\t\tadd s_y[%d]=%2.1f to c_xy[%d]=%2.1f.\n",iy, sp_y[iy],ib,c_xy[ib]);
            }
        }
    }
}
