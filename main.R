# Copyright 2016 Alberto Termanini

# USAGE: R --vanilla --slave --args --help < main.R;

# Input data: tab-delimited file with one line of header.
#             First column: numeric values to be plotted
#             Second column: string values with the class (there will be a beeswarm for each class)

#----------------------- GLOBALS:
rm(list=ls());
Sys.setlocale("LC_TIME", "en_US.UTF-8");
options(stringsAsFactors = F); 

#----------------------- LIBRARIES:
library("getopt");
library("beeswarm");

#----------------------- CONSTANTS:

#----------------------- FUNCTIONS:
verbose = function(txt) {
  dt = format(Sys.time(), "%Y-%m-%d %H:%M:%S");
  write(paste0("[", dt, "] ", txt), stderr());
}

#----------------------- PARAMETERS:
#0: no argument
#1: required argument
#2: optional argument
#args types: logical, integer, double, character
m = matrix(c(
  "help"   , "h", "0", "logical", "this help",
  "verbose", "v", "0", "logical", "verbose mode on",
  "infile", "i", "1", "character", "input file (tab-delimited file with header)",
  "outfile", "o", "1", "character", "output file (PDF plot)",
  "title", "t", "2", "character", "plot title (default = Beeswarm Plot)",
  "xlab", "x", "2", "character", "x-axys label (default = Groups)",
  "ylab", "y", "2", "character", "y-axys label (default = Value)"
), byrow=TRUE, ncol=5);
opt = getopt(spec = m, opt = commandArgs(TRUE));

# help:
if ( !is.null(opt$help) ) {
  cat(getopt(m, usage=TRUE));
  quit(status=1);
}

# defaults:
if ( is.null(opt$"verbose") )   { opt$"verbose" = FALSE; }
if ( is.null(opt$"title") )     { opt$"title" = "Beeswarm Plot"; }
if ( is.null(opt$"xlab") )      { opt$"xlab" = "Groups"; }
if ( is.null(opt$"ylab") )      { opt$"ylab" = "Value"; }

# print values:
if (opt$"verbose" == TRUE)  { print(opt); }

# requirements:
if ( is.null(opt$"infile") )		{ quit(status = 1); }
if ( is.null(opt$"outfile") )		{ quit(status = 1); }


#----------------------- READING DATA:
if (opt$"verbose" == TRUE) { verbose("Reading data"); };

if(file.exists(opt$"infile")) {
  
  d = read.table(opt$"infile", sep = "\t", header = TRUE);
  colnames(d) = c("VALUE","GROUP"); # forcing colnames

} else {
  
  verbose(paste0("ERROR: file does not exist, exit. File: ", opt$infile));
  quit(status = 1);
}


#----------------------- MAKING PLOT DATA:
if (opt$"verbose" == TRUE) { verbose("Making plot"); }
pdf(file=opt$"outfile");
beeswarm(VALUE ~ GROUP, 
         data = d,
         pch = 16,
         main = opt$"title",
         xlab = opt$"xlab", 
         ylab = opt$"ylab",
         cex = 0.8
);
bxplot(VALUE ~ GROUP, 
       data = d,
       col = c("grey","red","grey"),
       add = TRUE
);
dev.off();


#----------------------- SESSION INFO:
if(opt$"verbose") {
  
  sink(file = stderr());
  print(sessionInfo());    
}

#----------------------- EXIT:
quit(status=0);
