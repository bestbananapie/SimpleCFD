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
EXECUTABLES = iofunctions 
TARGET= cfd

# Makefile rules
all: $(TARGET)
iofunctions.o : iofunctions.c
				$(CC) $(CFLAGS) -c $^ -o iofunctions.o
$(TARGET): main.c
				$(CC) $(CFLAGS) $^ -o $(TARGET)

clean:
	rm -f *.o
