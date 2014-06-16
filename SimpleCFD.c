#include "SimpleCFD.h"
#include "iofunctions.h"

#include <math.h>
#include <stdio.h>

int i,j,k,t;

const double dens = 1000;
const double visco = 0.001002;

void intialise(fieldStruct *d) {
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

void momentum(fieldStruct *d) {
  (void) d;
  /*double ap, an, as, aw, ae;
  an = (visco/dy - 0.5*dens*d->v[i][j+1][k])*dx;
  as = (visco/dy + 0.5*dens*d->v[i][j-1][k])*dx;
  ae = (visco/dx - 0.5*dens*d->v[i+1][j][k])*dy;
  aw = (visco/dx - 0.5*dens*d->v[i-1][j][k])*dy;*/

}

double res_continuity(fieldStruct *d, meshStruct *mesh) {
  double sum = 0;
  for(k=1; k < Z_POINTS-1; k++){
    for(j=1; j < Y_POINTS-1; j++){
      for(i=1; i < X_POINTS-1; i++){
        sum += fabs(0.5*dens*(  (d->u[i+1][j][k]-d->u[i][j][k])/mesh->dx +(d->v[i][j+1][k]-d->v[i][j][k])/mesh->dy + (d->w[i][j][k+1]-d->u[i][j][k])/mesh->dz ));
      }
    }
  }
  return sum;
}

int main(){
/******************************************************************************/
/* Initialise Variables                                                       */
/******************************************************************************/
  char filename[100];
  fieldStruct d, d_old;
  meshStruct mesh;
  int print_succesful;

  printf("************************************************************\n");
  printf("***   Starting SimpleCFD                                 ***\n");
  printf("************************************************************\n");

  mesh.dx =(double) X_SIZE/X_POINTS;
  mesh.dy =(double) Y_SIZE/Y_POINTS;
  mesh.dz =(double) Z_SIZE/Z_POINTS;
  mesh.dt =(double) T_SIZE/T_POINTS;

/******************************************************************************/
/* Outer Loop                                                                 */
/******************************************************************************/
  for(t=0; t < T_POINTS; t++) {
    printf("*   Processing Timestep: %6f                          *\n",t*mesh.dt);
    printf("************************************************************\n");
    if ( t==0 ) {
      intialise(&d);
    }

    else {
      d=d_old;
    }

    printf("Continuity Residual: %f\n",res_continuity(&d, &mesh));
    sprintf(filename, "grid_%d.vtk",t);
    print_succesful = print_file(&d, &mesh, filename);
    if (print_succesful != 1) fprintf(stderr, "Unable to print\n");
    d_old = d;
  }

  return 0;
}












