# CFD Make File
# Common Configuration File
# Author   : Simon Lee (Imperial College)
# Email    : sel210@ic.ac.uk
# Date     : November 24th 2013

# Include the common configuration file
include config.mk

# Tell make that these are phony targets
.PHONY: all clean

# Build all of the executable files
EXECUTABLES = iofunctions.o SimpleCFD.o
TARGET= SimpleCFD

# Makefile rules
all: $(TARGET)

iofunctions.o : iofunctions.c
				$(CC) $(CFLAGS) -c $^ -o $@

SimpleCFD.o : SimpleCFD.c
				$(CC) $(CFLAGS) -c $^ -o $@

$(TARGET) : $(EXECUTABLES)
				$(CC) $^ -o $(TARGET)

clean:
	rm -f *.o
