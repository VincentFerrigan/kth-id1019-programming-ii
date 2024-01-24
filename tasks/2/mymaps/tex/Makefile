# Makefile       : Makefile
# Description    : Task 2, Maps
#                 
#                  This Makefile is for LaTeX only
# Course         : I1019 Programmering II
# Author/Student : Vincent Ferrigan
# maintainer     : ferrigan@kth.se

LATEX=lualatex
SOURCES=$(wildcard *.tex)
OUTPUT_DIR=output/tex
OBJECTS=$(addprefix $(OUTPUT_DIR)/,$(SOURCES:.tex=.pdf))

.PHONY: all clean clean_aux

all: $(OBJECTS)

$(OUTPUT_DIR)/%.pdf: %.tex
	mkdir -p $(OUTPUT_DIR)
	$(LATEX) -output-directory=$(OUTPUT_DIR) --shell-escape $<
	$(LATEX) -output-directory=$(OUTPUT_DIR) --shell-escape $<

clean:
	rm -rf $(OUTPUT_DIR)

clean_aux:
	rm -f $(OUTPUT_DIR)/*.aux $(OUTPUT_DIR)/*.log $(OUTPUT_DIR)/*.out $(OUTPUT_DIR)/*.toc $(OUTPUT_DIR)/*.synctex.gz
