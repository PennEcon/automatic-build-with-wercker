#!/bin/bash

# Builds anything that needs building, and moves the output to the out folder

pdflatex draft.tex
bibtex draft
pdflatex draft.tex
pdflatex draft.tex
mkdir out
mv draft.pdf out/draft.pdf
