\section{Utilities}
To automate working with \programname, a few utilities have been created.

\programname uses GNU Make to generate all the required files. It is used to
produce to produce the document and source files and compile as required. 

\subsection{Root Makefile}
The makefile that sits in the root directory of the project has targets to allow
it to compile the source, documentation and clean temporary files. By default it
outputs the source code.


%supress tab expansion and scrap indentation
@o ../Makefile -t -i @{
#Define phony targets
.PHONY: all doc

# Output the Source Code
all: SimpleCFD.w
	@< make-src @>

# Make the documents
doc: SimpleCFD.w
	@< make-doc @>
@}

\subsubsection{Source Output}
The all target 'TANGLES' the source text into the src folder with nuweb and
executes make within the source folder. It also explicitly scaffolds folders as necessary. 
@d make-src @{
	mkdir -p src
	nuweb -t -p src $^
	$(MAKE) -C src
@}

\subsubsection{Documentation Output}
The documentation is produced by `weaving' the source text. All the
documentation output is generated into a separation folder.

@d make-doc @{
	mkdir -p doc
	nuweb -o -p doc $^
	pdflatex --output-directory doc $(basename $^).tex
@}

Note: For all the cross references to be picked up correctly, this needs to be run at
least twice.

\section{Building and Compilation of Source}
The source code is compiled using GNU Make.

\subsection{Compile Configurations}
The configuration options of the complilation step sits in common folder to be
sharded across make files.

@o config.mk @{# Common Configuration File

## Default Compilers
CXX=g++
CC=gcc


## Flags for the C compiler
CCFLAGS  = -g 
CCFLAGS += -Wpointer-arith
CCFLAGS += -Wshadow -Winit-self
CCFLAGS += -Wextra
CCFLAGS += -Wfloat-equal
CCFLAGS += -Wall
CCFLAGS += -std=c99 
CCFLAGS += -pedantic
CCFLAGS += -O3
@}


\subsection{Comiling Source}
@o Makefile -t -i @{#Makefile for Codebase

## Include the common configuration file
include config.mk

##Define phony targets
.PHONY: all clean

SOURCES=$(wildcard *.c)
OBJECTS=$(SOURCES:.c=.o)
TARGET=../simplecfd

all: $(TARGET)

@% I need to escape @@ 
$(TARGET): $(OBJECTS)
	$(CC) -o $@@ $^

%.o: %.c
	$(CC) $(CCFLAGS) -c $<
@}
