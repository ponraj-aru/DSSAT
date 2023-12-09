# Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_181/")
# options(java.parameters = "-Xmx4g")
library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
##setwd and path Major FILEX path
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
FILEX <- "C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/DSSAT_KARNATAK/FILEX_DSSAT.xlsx"

### Read write and treatments in DSSAT Part
sheet <- read_excel(FILEX,sheet = "Harvesting_Details")
dfs <- split(sheet[2:ncol(sheet)],sheet$Name)
##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"Harvesting1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Harvesting"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Harvesting1/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Harvesting1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i],stringsAsFactors=FALSE, 
                colClasses = c("character"))
  colnames(FILE)[1] <- "H"
  hdr <- "*HARVEST DETAILS"
  write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
  #FILE$PDATE <- paste0("0",FILE$PDATE)
  FILE$H <- sprintf("%2d",as.integer(FILE$H))
  FILE$HDATE <- sprintf("%5s",FILE$HDATE)
  FILE$HSTG <- sprintf("%5s",FILE$HSTG)
  FILE$HCOM <- sprintf("%5s",FILE$HCOM)
  FILE$HSIZE <- sprintf("%5s",FILE$HSIZE)
  FILE$HPC <- sprintf("%5d",as.integer(FILE$HPC))
  FILE$HBPC <- sprintf("%5d",as.integer(FILE$HBPC))
  FILE$HNAME <- sprintf("%5s",FILE$HNAME)
  colnames(FILE)[1] <- "@H"
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
file.remove(FILES)

### Pate the header and dataframes 
genmodeldats <- function(inputfold,header,outdir){
  # Find common filenames in each folder
  filex <- tools::file_path_sans_ext(list.files(inputfold,pattern = "^.*\\.txt$"))
  # switchf <- tools::file_path_sans_ext(list.files(switchfold,pattern = "^.*\\.DAT$"))
  commonf <- Reduce(base::intersect,list(filex))
  # Now append all these files and write to outdir
  for(f in commonf){
    # New file name
    modeldat <- file.path(outdir,paste0(f,".txt"))
    #path for spliited filex
    filex1 <- file.path(inputfold,paste0(f,".txt"))
    cat("",file=modeldat,append=FALSE)
    for(i in c(header,filex1)){
      file.append(modeldat,i)
    }
    message("Filex written written to ",modeldat)
  }
}
genmodeldats(paste0(getwd(),"/Harvesting1/"),header = "hdr.txt",paste0(getwd(),"/Harvesting"))

unlink("Harvesting1",recursive = T)
file.remove("hdr.txt")
