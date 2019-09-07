#include <stdlib.h>
#include <stdio.h>
#include <math.h>


double *SOR(double *A, double *b, int size, double omega, double *x0) {
    double *x = malloc(sizeof(double) * size);

    double eps = 0.0000001;
    double error = 1;
    int nIter = 0;
    int maxIter = 5000;

    while(error > eps && nIter < maxIter) {
        nIter += 1;
        for(int i = 0; i < size; i++) {
            x[i] = b[i];
            if(i > 0)
                x[i] -= A[i*size+i-1] * x[i-1];
            if(i < size-1)
                x[i] -= A[i*size+i+1] * x0[i+1];
            
            if(fabs(A[i*size+i]) > 1E-10) {
                x[i] /= A[i*size+i];
                x[i] = omega*x[i] + (1-omega)*x0[i];
            }
        }
        double norm = 0;
        for(int i = 0; i < size; i++) {
            if(fabs(x[i]-x0[i]) > norm)
                norm = fabs(x[i]-x0[i]);
            x0[i] = x[i];
        }
    }

    return x;
}
