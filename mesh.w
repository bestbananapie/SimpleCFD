\newpage
\section{mesh}

\subsection{Introduction}
The code only works with rectagular cells in an unstructured grid. The mesh is defined by a point cloud and each cell has 8 nodes.

Each node is defined by a 3 dimensional vector.


\subsubsection{Data Structure}
@d mesh-data-structures @{
typedef struct {
    int vtk_type;
    int *nodes;
} struct_cell;

typedef struct {
    int num_points;
    int num_cells;
    float scale;
    int **points;
    struct_cell *cells;
    int mem_allocated;
} struct_mesh;

typedef struct {
    int num_points;
    int num_cells;
    float scale;
    int **points;
    struct_cell *cells;
    int mem_allocated;
} struct_domain;
@}

\subsubsection{Mesh Definition}
\todo{Mesh definition to be input at runtime.}
@d mesh-def @{
    int domain_min[3];
    int domain_max[3];

    int domain_seedsize[3];

    domain_min[0] = 0;
    domain_min[1] = 0;
    domain_min[2] = 0;

    domain_max[0] = 20;
    domain_max[1] = 10;
    domain_max[2] = 10;

    /* this is actually half delta */
    domain_seedsize[0] = 5;
    domain_seedsize[1] = 5;
    domain_seedsize[2] = 5;

    mesh->num_points = 0;
    mesh->num_cells = 0;
    mesh->scale = 1e-3;
@}
\subsection{Generating Mesh}

\subsubsection{Generating Vertex List}
@d generate-mesh-vertex @{
/* Generate Vertices */
    p = 0;

    pos[0] = 0;
    pos[1] = 0;
    pos[2] = 0;

    while(pos[2] <= domain_max[2]){
        while(pos[1] <= domain_max[1]){
            while(pos[0] <= domain_max[0]){
                points[p][0] = pos[0];
                points[p][1] = pos[1];
                points[p][2] = pos[2];
                p++;

                /* Increment position */
                pos[0] += domain_seedsize[0];
                ++vertex_count[0];
            }
            pos[1] += domain_seedsize[1];
            ++vertex_count[1];
        }
        pos[2] += domain_seedsize[2];
        ++vertex_count[2];
    }
@}
@d generate-mesh-cells @{
/* Create Cells */
    for(c=0; c < mesh->num_cells ; c++){
        cells[c].nodes = malloc(9*sizeof(int));
        cells[c].vtk_type = 11;

        n = 0;
        while(pos[2] <= domain_max[2]){
            while(pos[1] <= domain_max[1]){
                while(pos[0] <= domain_max[0]){
                    xindex = (int) (x-xmin)/(2*dx);  
                    yindex = (int) (y-ymin)/(2*dy);  
                    zindex = (int) (z-zmin)/(2*dz);  
                    cells[c].nodes[n]  = zindex * (xcount+1) * (ycount*1);
                    cells[c].nodes[n] += yindex * (xcount+1);
                    cells[c].nodes[n] += xindex;
                    n++;
                }
            }
        }
    }
@}

@d func-generate-mesh @{

int generate_mesh(struct_domain * domain, struct_mesh * mesh){
    int n,c,p;

    int pos[3];

    int xindex;
    int yindex;
    int zindex;

    int **points;
    struct_cell *cells;

    int vertex_count[0] = 0;
    int vertex_count[1] = 0;
    int vertex_count[2] = 0;

    @< mesh-def @>

    printf("mesh points %d\n", mesh->num_points);
    printf("mesh cells %d\n", mesh->num_cells);
    
/* Mememory Allocation */
    
    // Lets guess a mesh size...
    mesh->num_points = (vertex_count[0]+1)*(vertex_count[1]+1)*(vertex_count[2]+1)
    mesh->num_cells = xcount * ycount * zcount;

    //... and allocate it
    mesh->mem_allocated = 0;
    mesh_mem_allocate(mesh);
    

    @< generate-mesh-vertex @>

    @< generate-mesh-cells @>

    mesh->points = points;
    mesh->cells = cells;
    return 0;
}

@}

\subsubsection{Dynamic Memory Allocation}

\paragraph{Memory Allocation}
Memory for the mesh get allocations based on the number of vertices and cells stored within the mesh data structure.
\todo{Reallocate memory for mesh}

@d mesh-mem-allocation @{/* Allocate memory for mesh */
int mesh_mem_allocate(struct_mesh * mesh){

    if(mesh->mem_allocated ==0){
        /* Allocate Memeory for Points */
        mesh->points = malloc(mesh->num_points*sizeof(*points) + mesh->num_points*3*sizeof(**points));

        int *data;
        data = &points[mesh->num_points];
        for(n=0; n < mesh->num_points; n++){
            points[n] = data + n * 3;
        }

        /* Allocate Memeory for Cells */
        cells = malloc(mesh->num_cells*sizeof(*cells));

        mesh->mem_allocated = 1;
    }
    else {
        /* Reallocate Memory */
    }
   
   return 0;
}
@}

\paragraph{Free Memory}
@d mesh-mem-free @{/* Free memory allocated to mesh */
int mesh_mem_free(struct_mesh * mesh){

   free(mesh->points)
   free(mesh->cells)
   return 0;
}
@}



\subsection{Exporting Mesh}
The mesh can be exported to a vtk file format to be read in Paraview.

@d func-mesh-print-vtk @{#Export mesh to VTK
int mesh_print_vtk(struct_mesh *mesh, char *filename) {
    int n;
    FILE * fp;
    fp = fopen(filename,"w");
    
@< snippet-mesh-print-vtk-header @>

@< snippt-mesh-print-vtk-vertices @>

@< snippt-mesh-print-vtk-cells @>

    fclose(fp);

    return 0;
    }
@}

\subsubsection{VTK Header}
It currently defaults to an unstructed grid
@d snippet-mesh-print-vtk-header @{/* Print file header */
    fprintf(fp, "# vtk DataFile Version 2.0\n"
                "SimpleCFD VTK Output\n"
                "ASCII\n"
                "DATASET UNSTRUCTURED_GRID\n");
@}

\subsubsection{Print Vertices}
@d snippt-mesh-print-vtk-vertices @{/* Print Vertices */
    fprintf(fp, "\nPOINTS %d FLOAT\n", mesh->num_points);

    for(n=0; n < mesh->num_points; n++){
        fprintf(fp, "%+e %+e %+e\n", (float) mesh->points[n][0] * mesh->scale,
                                     (float) mesh->points[n][1] * mesh->scale,
                                     (float) mesh->points[n][2] * mesh->scale);
    }
@}
\subsubsection{Printing Cells Information}
Each cell is defined by 8 vertices. Type 12 refers to a VTK relationship between nodes.

@d snippt-mesh-print-vtk-cells @{/* Print Cell Information */
    fprintf(fp, "\nCELLS %d %d \n", mesh->num_cells, mesh->num_cells * 9);

    for(n=0; n < mesh->num_cells; n++){
        fprintf(fp, "8 %d %d %d %d %d %d %d %d\n", mesh->cells[n].nodes[0],
                                                   mesh->cells[n].nodes[1],
                                                   mesh->cells[n].nodes[2],
                                                   mesh->cells[n].nodes[3],
                                                   mesh->cells[n].nodes[4],
                                                   mesh->cells[n].nodes[5],
                                                   mesh->cells[n].nodes[6],
                                                   mesh->cells[n].nodes[7]);
    }

/* Print Cell Types */
    fprintf(fp, "\nCELL_TYPES %d \n", mesh->num_cells);

    for(n=0; n < mesh->num_cells; n++){
        fprintf(fp, "12 \n");
    }
@}

\subsection{Source file}
All the functions get written to a common source file.

@o mesh.h @{
#ifndef MESH_H
#define MESH_H

@< mesh-data-structures @>

int generate_mesh(struct_mesh * mesh);

int mesh_print_vtk(struct_mesh *mesh, char *filename);

#endif
@}

@o mesh.c @{
#include "mesh.h" 
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

@< mesh-mem-free @>

@< mesh-mem-allocation @>

@< func-generate-mesh @>

@< func-mesh-print-vtk @>
@}

