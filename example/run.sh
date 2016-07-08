#!/bin/bash

R --vanilla --slave --args --infile "data.tab" --outfile "plot.pdf" --title "Beeswarm Plot" --xlab "Group" --ylab "Value" < ../main.R;
