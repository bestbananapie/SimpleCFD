.PHONY: all doc clean

# Build all of the executable files
all:
	$(MAKE) -C src

# Build Doxygen
doc:
	$(MAKE) -C doxygen

# Clean up the executable files
clean:
	$(MAKE) -C src clean
	$(MAKE) -C doxygen clean
