\documentclass[a4paper,11pt]{article}

\begin{document}

\section{Introduction}

I have long had the idea to write my own, but very simple, CFD solver.

My initial goal is the solve for the case of a flow through a rectangular box/duct. The only reason for this is that the grid/mesh should be very easy.

\section{Usage}
\subsection{Compiling}

I use a makefile to handle all compilation steps. 
\begin{enumerate}
\item I need it to scaffold out the folders.
\end{enumerate}

The main make file by default (all) makes the source code. Running make doc creates the latex document

%supress tab expansion and scrap indentation
@o ../Makefile -t -i @{
.PHONY: all doc
	@< make-src @>
	@< make-doc @>
@}


I like to make the documentation into a separate folder as well.
@d make-doc @{
# Make the documents
doc: SimpleCFD.w
	mkdir -p doc
	nuweb -o -p doc $^
	pdflatex --output-directory doc $(basename $^).tex
@}
Please note that this will need to be run twice to get all the references correct

@d make-src @{
# Output the Source Code
all: SimpleCFD.w
	mkdir -p src
	nuweb -t -p src $^
@}

\section{preprocessor}
@o preprocessor.c @{
    @< preprocessoptions @>
    @< preprocesser-ReadMesh @>
@}

\section{postprocessor}
@o postprocessor.c @{
    @<printvtkfile@>
@}


\section{Solver}

@o solver.c @{

    @< solverInitialisation @> 

    @< solverReadData @>

    @< allSimpleCFD @>
@}

\newpage

@d allSimpleCFD @{
#include "SimpleCFD.h"
#include "iofunctions.h"

#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

int i,j,k,t;
int verbose = 0;
char dir[255] = "";

const double dens = 1000;
const double visco = 0.001002;
void solver(fieldStruct *d, fieldStruct *d_old, meshStruct *mesh)
{
  int n;
  (void) mesh;

  for(n=0; n < 1000; n++)
  {
    for(k=0; k < Z_POINTS; k++)
    {
      for(j=0; j < Y_POINTS; j++)
      {
        for(i=0; i < X_POINTS; i++)
        {
          if ( i == 0 || j==0 || i==X_POINTS-1 || j==Y_POINTS-1 )
          {
            if ( INLET_MIN <= i && i <= INLET_MAX && j==0)
            {
              d->u[i][j][k]=0;
              d->v[i][j][k]=100*(sin( (double) t/T_POINTS * M_PI));
              d->w[i][j][k]=0;
              d->p[i][j][k]=0;
            }
            else if ( OUTLET_MIN <=i && i <= OUTLET_MAX && j==0)
            {
              d->u[i][j][k]=0;
              d->v[i][j][k]=-100 * (sin( (double) t/T_POINTS * M_PI));
              d->w[i][j][k]=0;
              d->p[i][j][k]=0;
            }
            else
            {
              d->u[i][j][k]=0;
              d->v[i][j][k]=0;
              d->w[i][j][k]=0;
              d->p[i][j][k]=0;
            }

          }
          else
          {
            d->u[i][j][k]=0.2*d_old->u[i][j][k] + 0.6*(d->u[i-1][j-1][k]
                                                      +d->u[i-1][j+1][k]
                                                      +d->u[i+1][j-1][k]
                                                      +d_old->u[i+1][j+1][k])/4;
            d->v[i][j][k]=0.2*d_old->v[i][j][k] + 0.6*(d->v[i-1][j-1][k]
                                                      +d->v[i-1][j+1][k]
                                                      +d_old->v[i+1][j-1][k]
                                                      +d_old->v[i+1][j+1][k])/4;
            d->w[i][j][k]=0;
            d->p[i][j][k]=0;
          }
        }
      }
    }
    d_old = d;
  }
}
void intialise(fieldStruct *d) {
  for(k=0; k < Z_POINTS; k++){
    for(j=0; j < Y_POINTS; j++){
      for(i=0; i < X_POINTS; i++){
        if ( i == 0 || j==0 || k==0 || i==X_POINTS-1 || j==Y_POINTS-1 || k==Z_POINTS-1){
          if ( INLET_MIN <= i && i <= INLET_MAX && j==0) {
            d->u[i][j][k]=0;
            d->v[i][j][k]=1;
            d->w[i][j][k]=0;
            d->p[i][j][k]=0;
          }
          else if ( OUTLET_MIN <=i && i <= OUTLET_MAX && j==0){
            d->u[i][j][k]=0;
            d->v[i][j][k]=-1;
            d->w[i][j][k]=0;
            d->p[i][j][k]=0;
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

void print_opthelp() {
  printf("Arguments: \n");
  printf("%-15s : %s\n", "-v or -verbose", "Prints all information to console");
  printf("%-15s : %s\n", "-d or -dir", "Directory to save result files");
  printf("%-15s : %s\n", "-h or -help", "Print help file");
}


int main(int argc, char **argv){
  int opt = 0;

  fieldStruct d, d_old;
  meshStruct mesh;
  int print_succesful;
  char filename[100];


/******************************************************************************/
/* Process Variables                                                          */
/******************************************************************************/
  int option_index = 0;
  static struct option long_options[] = {
    {"directory", required_argument, 0, 'd'},
    {"verbose", no_argument, 0, 'v'},
    {"help", no_argument, 0, 'h'}
  };

  /* If no arguments are given */
  if (argc == 1) {
    printf("No Arguments given\n");
    print_opthelp();
  }

  /* Process Given Arguments */
  while ( (opt = getopt_long_only(argc, argv, "hvd:", long_options, &option_index)) != -1) {

      /* Possible Options */
      switch (opt) {
        case 'h':
          print_opthelp();
          break;
        case 'v':
          verbose = 1;
          puts("Console Output Enabled");
          break;
        case 'd':
          sprintf(dir,"./%s/",optarg);
          printf("option -d with value %s \n", optarg);
          break;
        case '?' :
          printf("Unrecognised option\n");
          print_opthelp();
          break;
      }
  }
/******************************************************************************/
/* Initialise Variables                                                       */
/******************************************************************************/
  if(verbose == 1){
    printf("************************************************************\n");
    printf("***   Starting SimpleCFD                                 ***\n");
    printf("************************************************************\n");
  }

  mesh.dx =(double) X_SIZE/X_POINTS;
  mesh.dy =(double) Y_SIZE/Y_POINTS;
  mesh.dz =(double) Z_SIZE/Z_POINTS;
  mesh.dt =(double) T_SIZE/T_POINTS;

/******************************************************************************/
/* Outer Loop                                                                 */
/******************************************************************************/
  for(t=0; t < T_POINTS; t++) {
    if(verbose == 1){
      printf("*   Processing Timestep: %6f                          *\n",t*mesh.dt);
      printf("************************************************************\n");
    }
    if ( t==0 ) {
      intialise(&d);
    }

    solver(&d,&d_old,&mesh); 

    if(verbose == 1){
      printf("Continuity Residual: %f\n",res_continuity(&d, &mesh));
    }

    sprintf(filename, "%sgrid_%d.vtk",dir,t);
    print_succesful = print_file(&d, &mesh, filename);
    if (print_succesful != 1) fprintf(stderr, "Unable to print\n");
    d_old = d;
  }

  return 0;
}












@}


\end{document}
