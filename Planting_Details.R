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
sheet <- read_excel(FILEX,sheet = "Planting_Details")
## split sheet intoi multiple dat frames for creating mutple filex files
dfs <- split(sheet[2:ncol(sheet)],sheet$Name)
##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"Planting1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Planting"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Planting1/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Planting1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i],stringsAsFactors=FALSE, 
                colClasses = c("character"))
  colnames(FILE)[1] <- "P"
  hdr <- "*PLANTING DETAILS"
  write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
  #FILE$PDATE <- paste0("0",FILE$PDATE)
  ifelse(FILE$EDATE>-99,paste0("0",FILE$EDATE),FILE$EDATE)
   FILE$P <- sprintf("%2d",as.integer(FILE$P))
   FILE$PDATE <- sprintf("%5s",FILE$PDATE)
   FILE$EDATE <- sprintf("%5s",FILE$EDATE)
   FILE$PPOP <- sprintf("%5d",as.integer(FILE$PPOP))
   FILE$PPOE <- sprintf("%5d",as.integer(FILE$PPOE))
   FILE$PLME <- sprintf("%5s",as.character(FILE$PLME))
   FILE$PLDS <- sprintf("%5s",FILE$PLDS)
   FILE$PLRS <- sprintf("%5d",as.integer(FILE$PLRS))
   FILE$PLRD <- sprintf("%5d",as.integer(FILE$PLRD))
   FILE$PLDP <- sprintf("%5d",as.integer(FILE$PLDP))
   FILE$PLWT <- sprintf("%5d",as.integer(FILE$PLWT))
   FILE$PAGE <- sprintf("%5d",as.integer(FILE$PAGE))
   FILE$PENV <- sprintf("%5d",as.integer(FILE$PENV))
   FILE$PLPH <- sprintf("%5d",as.integer(FILE$PLPH))
   FILE$SPRL <- sprintf("%5d",as.integer(FILE$SPRL))
   FILE$PLNAME <- sprintf("%32s",FILE$PLNAME)
   colnames(FILE)[1] <- "@P"
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
genmodeldats(paste0(getwd(),"/Planting1/"),header = "hdr.txt",paste0(getwd(),"/Planting"))

unlink("Planting1",recursive = T)
file.remove("hdr.txt")


####