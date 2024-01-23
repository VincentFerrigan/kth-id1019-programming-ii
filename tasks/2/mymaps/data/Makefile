# Makefile to run all GNUPlot scripts in the directory

.PHONY: all clean plots

# Default target
all: plots

# Find all .gnuplot files in the directory
GNUPLOT_SCRIPTS := $(wildcard *.gnuplot)

# Corresponding output .png files for each .gnuplot script
PNG_FILES := $(GNUPLOT_SCRIPTS:.gnuplot=.png)

# Target to generate all plots
plots: $(PNG_FILES)

# Rule to run GNUPlot on each script
%.png: %.gnuplot
	gnuplot $<

# Clean up all generated .png files
clean:
	rm -f $(PNG_FILES)

