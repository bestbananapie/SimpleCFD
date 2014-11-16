#!/bin/bash

#Generate tags file
ctags -R .

#Generate Doxygen Documentation
doxygen Doxyfile
