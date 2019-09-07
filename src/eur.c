#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <assert.h>
#include <time.h>

#define MYMAX(x,y) ((x > y) ? x : y)
#define ABSOL(x)   ((x > 0) ? x : -x)

void eur() {
    double sig2 = 0.04; double E = 10; double r = 0.05;
    double T = 1.0; double b = 50.0;
    int nt = 599; double dt = (T / (double)(nt+1));
    int ns = 599; double ds = (b / (double)(ns+1));

    double eps = 1E-8;
    int maxIter = 5000;
    double omega = 1.35;
	
    double *values = malloc(sizeof(double) * ns*nt);
    
    #pragma omp parallel for
    for(int i = 0; i < ns; i++)
        values[(nt-1)*ns+i] = MYMAX(E-i*ds, 0);

    double *Aj = malloc(sizeof(double) * ns*ns);
    double *bj = malloc(sizeof(double) * ns);
    double *uj = malloc(sizeof(double) * ns);
    
    double center, left, right;
    
    for(int i = nt-1; i >= 1; i--) {
        for(int j = 0; j < ns; j++) {
            double j2 = (j+1)*(j+1);
            double c = (sig2*j2-2/dt);
            center = -sig2*j2-2*r-2/dt;
            left   = (sig2*j2-r*(j+1))/2;
            right  = (sig2*j2+r*(j+1))/2;

            int main_diag = j*ns+j;
            Aj[main_diag] = center;
            if(j > 0)    Aj[main_diag-1] = left;
            if(j < ns-1) Aj[main_diag+1] = right;

            int index = i*ns + j;
            bj[j] = c*values[index];
            if(j == 0)
                bj[j] -= right*values[index+1] - 2*left*E;
            else if(j == ns-1)
                bj[j] -= left*values[index-1];
            else
                bj[j] -= (right*values[index+1]  + left*values[index-1]);
        }

        double error = 1.0;
        int nIter = 0;

        double temp[ns];
        memcpy(temp, &values[i*ns], sizeof(double)*ns);

        while(error > eps && nIter < maxIter) {
            nIter += 1;
            for(int j = 0; j < ns; j++) {
                int m_center = j*ns+j;
                uj[j] = bj[j];
                if(j > 0)
                    uj[j] -= Aj[m_center-1] * uj[j-1];
                if(j < ns-1)
                    uj[j] -= Aj[m_center+1] * temp[j+1];
                
                if(ABSOL(Aj[m_center]) > 1E-8) {
                    uj[j] /= Aj[m_center];
                    uj[j] = omega*uj[j] + (1-omega)*temp[j];
                }
            }
            double norm = 0;
            for(int j = 0; j < ns; j++) {
                norm = MYMAX(ABSOL(uj[j]-temp[j]), norm);
            }
            
            error = norm;
            
            for(int j = 0; j < ns; j++)
                temp[j] = uj[j];
        }
       
        memcpy(&values[(i-1)*ns], uj, sizeof(double)*ns);
        
    }

    free(Aj);
    free(bj);
    free(uj);

    int num_tests[13] = {2,4,6,7,8,9,10,11,12,13,14,15,16};

    for(int i = 0; i < 13; i++) {
        int si = (int) ((double) num_tests[i] / ds);
        int ti = (int) (0.5 / dt) + 1;

        printf("%d %12.10f \n", num_tests[i], values[ti*ns+si]);
    }

    free(values);
}


int main() {
    double start = clock();
    eur();
    printf("%f seconds\n", (clock()-start)/ CLOCKS_PER_SEC);

    return 0;
}
