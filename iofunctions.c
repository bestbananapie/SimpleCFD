#include "iofunctions.h"

void print_file(data *d, char *filename) {
    FILE * fp;
    fp = fopen(filename,"w");
    fprintf(fp, "# vtk DataFile Version 2.0\n"
                "Cool CFD Script\n"
                "ASCII\n"
                "DATASET STRUCTURED_POINTS\n"
                "DIMENSIONS %d %d %d\n"
                "ORIGIN %f %f %f\n"
                "SPACING %f %f %f\n\n",X_POINTS,Y_POINTS,Z_POINTS,0.0,0.0,0.0,dx,dy,dz);

    fprintf(fp, "POINT_DATA %d\n"
                "SCALARS %s float 1\n"
                "LOOKUP_TABLE default\n",X_POINTS*Y_POINTS*Z_POINTS,"Pressure");

    for(k=0; k < Z_POINTS; k++){
        for(j=0; j < Y_POINTS; j++){
            for(i=0; i < X_POINTS; i++){
                fprintf(fp,"%.1f ",d->p[i][j][k]);
            }
            fprintf(fp,"\n");
        } 
    }

    fprintf(fp, "VECTORS %s float\n","Velocity");
    for(k=0; k < Z_POINTS; k++){
        for(j=0; j < Y_POINTS; j++){
            for(i=0; i < X_POINTS; i++){
                fprintf(fp,"%.1f %.1f %.1f \n",d->u[i][j][k], d->v[i][j][k], d->w[i][j][k]);
            }
        } 

    }
    fclose(fp);
}
