## Get info about LDC data set

## directories
chr.dir <- "//deqhq1/tmdl/TMDL_WR/MidCoast/Models/Bacteria/LDC"
chr.dir.data <- paste0(chr.dir,"/Results")

## get total number of concentrations used
chr.ls0 <- list.files(path=chr.dir.data,pattern="bacteria_DataCleaning_*.",recursive=TRUE)
chr.ls1 <- chr.ls0[-grep("^[aA]rchive",chr.ls0)]
## watershed naes
unique(gsub("\\/clean.*","",chr.ls1))
## load data sets
load(paste0(chr.dir.data,"/",chr.ls1[1]))
N <- sum(is.finite(as.numeric(bacteria.data[as.numeric(format(bacteria.data$date,format="%Y")) > 1993,"RESULT.trn"])))
for(ii in 2:length(chr.ls1)) {
  rm(bacteria.data)
  load(paste0(chr.dir.data,"/",chr.ls1[ii]))
  N <- N + sum(is.finite(as.numeric(bacteria.data[as.numeric(format(bacteria.data$date,format="%Y")) > 1993,"RESULT.trn"])))
}
N
