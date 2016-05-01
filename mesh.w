\section{mesh}


\subsubsection{Data Structure}
The code only works with rectagular cells in an unstructured grid. The mesh is defined by a point cloud and each cell has 8 nodes.


typedef struct {
    int num_points;
    int num_cells;
    float points[];
    float 
} meshStruct;

#include <stdio.h>
#include <stdlib.h>


/* Check Header File for documentation */
int vtk_print_mesh(meshStruct *mesh, char *filename) {
    int i,j,k;
    FILE * fp;
    fp = fopen(filename,"w");
    
    /* Print file header */
    fprintf(fp, "# vtk DataFile Version 2.0\n"
                "SimpleCFD VTK Output\n"
                "ASCII\n"
                "DATASET UNSTRUCTURED_GRID\n\n");

    /* Print Points */
    fprintf(fp, "POINTS %d FLOAT\n", mesh.num_points);

    for(n=0; n < mesh.num_points; n++){
        fprintf(fp, "%E %E %E\n", mesh.points[n].x,
                                  mesh.points[n].y,
                                  mesh.points[n].z);
    }

    fprintf(fp, "\n");

    /* Print Cells */
    fprintf(fp, "CELLS %d %d \n", mesh.num_cells, mesh.numcells * 9);

    for(n=0; n < num_cells; n++){
        fprintf(fp, "8 %d %d %d %d %d %d %d %d\n", mesh.cells[n].nodes[0],
                                                   mesh.cells[n].nodes[1],
                                                   mesh.cells[n].nodes[2],
                                                   mesh.cells[n].nodes[3],
                                                   mesh.cells[n].nodes[4],
                                                   mesh.cells[n].nodes[5],
                                                   mesh.cells[n].nodes[6],
                                                   mesh.cells[n].nodes[7]);
    }

    fprintf(fp, "\n");

    /* Print Types */
    fprintf(fp, "CELL_TYPES %d \n", mesh.num_cells, mesh.numcells * 9);

    for(n=0; n < num_cells; n++){
        fprintf(fp, "12 \n");
    }
    fprintf(fp, "\n");


    fclose(fp);

    return 1;
}


