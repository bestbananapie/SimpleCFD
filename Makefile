
#Define phony targets
.PHONY: all doc
	
# Output the Source Code
all: SimpleCFD.w
	mkdir -p src
	nuweb -t -p src $^
	$(MAKE) -C src

	
# Make the documents
doc: SimpleCFD.w
	mkdir -p doc
	nuweb -o -p doc $^
	pdflatex --output-directory doc $(basename $^).tex

