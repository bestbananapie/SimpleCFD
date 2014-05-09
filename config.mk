# Simple CFD
# Common Configuration File
# Author   : Simon Lee (Imperial College)
# Email    : sel210@ic.ac.uk
# Date     : November 24th 2013

# This a common configuration file that includes definitions used by all
# the Makefiles.

# C++ compiler
CXX=g++
CC=colorgcc

# Flags for the C++ compiler
CFLAGS=-Wall -ansi -pedantic -O3

# Relative include and library paths for compilation of the examples
E_INC=-I./src_voro++
E_LIB=-L./src_voro++


