\documentclass[a4paper,11pt]{article}
\newcommand{\programname}{SimpleCFD }

%Better margins
    \usepackage[left=1in, right=1in, top=1.5in, bottom=1.5in]{geometry}

%Better Font
    \usepackage{lmodern}
    \usepackage[T1]{fontenc}

% Smartter text spacing
    \usepackage{microtype}

% Format paragraphs without indentation
\usepackage[parfill]{parskip}

% Create Todos
\usepackage[colorinlistoftodos,prependcaption,textsize=tiny]{todonotes}

%Create links in PDF
    \usepackage[hidelinks]{hyperref}

\title{\programname}
\author{Simon Lee}
\date{\today}

\begin{document}

\maketitle
\newpage

\tableofcontents
\newpage

\section{Todos}
\listoftodos
\section{Introduction}

I have long had the idea to write my own, but very simple, CFD solver.

My initial goal is the solve for the case of a flow through a rectangular box/duct. The only reason for this is that the grid/mesh should be very easy.


@o main.c @{
#include "mesh.h"
#include <stdio.h>
int main(void){
    struct_mesh mesh;
    generate_mesh(&mesh);
    mesh_print_vtk(&mesh,"test.vtk");
    printf("Hello World %d %d\n",mesh.num_points, mesh.num_cells);
    return 0;
}
@}


@i mesh.w

\section{preprocessor}
@d preprocessor.c @{
@%    @< preprocessoptions @>
@%    @< preprocesser-ReadMesh @>
@}

\section{postprocessor}
@d postprocessor.c @{
@%   @<printvtkfile@>
@}


\section{Solver}

@d solver.c @{

@%    @< solverInitialisation @> 

@%    @< solverReadData @>

@%    @< allSimpleCFD @>
@}

\appendix

@i utilities.w


\end{document}
