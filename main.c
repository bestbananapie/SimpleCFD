#include <stdio.h>

#include <math.h>

#include "options.h"
#include "iofunctions.h"

int i,j,k,t;
const double dx = X_SIZE/X_POINTS;
const double dy = Y_SIZE/Y_POINTS;
const double dz = Z_SIZE/Z_POINTS;

const double dens = 1000; 
const double visco = 0.001002;
typedef struct {
    double u[X_POINTS][Y_POINTS][Z_POINTS];
    double v[X_POINTS][Y_POINTS][Z_POINTS];
    double w[X_POINTS][Y_POINTS][Z_POINTS];
    double p[X_POINTS][Y_POINTS][Z_POINTS];
} data;

void intialise(data *d) {
    for(k=0; k < Z_POINTS; k++){
        for(j=0; j < Y_POINTS; j++){
            for(i=0; i < X_POINTS; i++){
                if ( i == 0 || j==0 || k==0 || i==X_POINTS-1 || j==Y_POINTS-1 || k==Z_POINTS-1){
                    if ( INLET_MIN <= i && i <= INLET_MAX && j==0) {
                        d->u[i][j][k]=0;
                        d->v[i][j][k]=1000000;
                        d->w[i][j][k]=0;
                        d->p[i][j][k]=0;
                    }
                    else if ( OUTLET_MIN <=i && i <= OUTLET_MAX && j==0){
                        d->u[i][j][k]=0;
                        d->v[i][j][k]=0;
                        d->w[i][j][k]=0;
                        d->p[i][j][k]=10;
                    }
                    else {
                        d->u[i][j][k]=0;
                        d->v[i][j][k]=0;
                        d->w[i][j][k]=0;
                        d->p[i][j][k]=0;
                    }

                }
                else {
                    d->u[i][j][k]=0;
                    d->v[i][j][k]=0;
                    d->w[i][j][k]=0;
                    d->p[i][j][k]=0;
                }
            }
        } 
    }   
}

void momentum(data *d) {
    double ap, an, as, aw, ae;
    an = (visco/dy - 0.5*dens*d->v[i][j+1][k])*dx;
    as = (visco/dy + 0.5*dens*d->v[i][j-1][k])*dx;
    ae = (visco/dx - 0.5*dens*d->v[i+1][j][k])*dy;
    aw = (visco/dx - 0.5*dens*d->v[i-1][j][k])*dy;

}

double res_continuity(data *d) {
    double sum = 0;
    for(k=1; k < Z_POINTS-1; k++){
        for(j=1; j < Y_POINTS-1; j++){
            for(i=1; i < X_POINTS-1; i++){
                sum += abs(0.5*dens*(  (d->u[i+1][j][k]-d->u[i][j][k])/dx +(d->v[i][j+1][k]-d->v[i][j][k])/dy + (d->w[i][j][k+1]-d->u[i][j][k])/dz ));   
            }
        }
    }
    return sum;
}

int main(){

    char filename[100];
    data d, d_old;
    for(t=0; t < T_POINTS; t++) {
        if ( t==0 ) {
            intialise(&d);
        }

        else {
            d=d_old;
        }

        printf("Continuity Residual: %f\n",res_continuity(&d));
        sprintf(filename, "grid_%d.vtk",t);
        print_file(&d,filename);    
        d_old = d;
    } return 0;
}
