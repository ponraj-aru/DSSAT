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
sheet <- read_excel(FILEX,sheet = "Location_Info")
sheet_a <- sheet[,11:15]
sheet_b <- unique(sheet_a)
## split sheet intoi multiple dat frames for creating mutple filex files
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet_b$GRID_NAME)
##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"Cultivar1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Cultivar"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Cultivar1/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Cultivar1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  colnames(FILE)[1] <- "C"
  hdr <- "*CULTIVARS"
  write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
  FILE$C <- sprintf("%2d",FILE$C)
  FILE$CR <- sprintf("%2s",FILE$CR)
  FILE$INGENO <- sprintf("%6s",FILE$INGENO)
  FILE$CNAME <- sprintf("%-12s",FILE$CNAME)
  colnames(FILE)[1] <- "@C"
  #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
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
genmodeldats(paste0(getwd(),"/Cultivar1/"),header = "hdr.txt",paste0(getwd(),"/Cultivar"))

unlink("Cultivar1",recursive = T)
file.remove("hdr.txt")


####