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
sheet_f1 <- read_excel(FILEX,sheet = "Fields")
sheet_f2 <- read_excel(FILEX,sheet = "Fields1")
## split sheet intoi multiple dat frames for creating mutple filex files
dfs <- split(sheet_f1[2:ncol(sheet_f1)],sheet_f1$Name)
dfs1 <- split(sheet_f2[2:ncol(sheet_f2)],sheet_f2$Name)
##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"Fields1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Fields2"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Fields"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Fields1/",i,".csv"),row.names = F)
}
for (i in names(dfs1)){
  write.csv(dfs1[[i]],paste0(getwd(),"/Fields2/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Fields1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  colnames(FILE)[1] <- "L"
   hdr <- "*FIELDS"
   write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
  #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  #cat("*FIELDS\n", file = FILE)
  #cat("@L ID_FIELD WSTA....  FLSA  FLOB  FLDT  FLDD  FLDS  FLST SLTX  SLDP  ID_SOIL    FLNAME\n")
  FILE$L <- sprintf("%2d",as.integer(FILE$L))
  FILE$ID_FIELD <- sprintf("%-8s",FILE$ID_FIELD)
  FILE$WSTA.... <- sprintf("%-8s",FILE$WSTA....)
  FILE$FLSA <- sprintf("%5d",as.integer(FILE$FLSA))
  FILE$FLOB <- sprintf("%5d",as.integer(FILE$FLOB))
  FILE$FLDT <- sprintf("%5s",FILE$FLDT)
  FILE$FLDD <- sprintf("%5d",as.integer(FILE$FLDD))
  FILE$FLDS <- sprintf("%5s",as.integer(FILE$FLDS))
  FILE$FLST <- sprintf("%5d",as.integer(FILE$FLST))
  FILE$SLTX <- sprintf("%-4s",FILE$SLTX)
  FILE$SLDP <- sprintf("%6d",as.integer(FILE$SLDP))
  FILE$ID_SOIL <- sprintf("%-10s",FILE$ID_SOIL)
  FILE$FLNAME <- sprintf("%-8s",FILE$FLNAME)
  colnames(FILE)[1] <- "@L"
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
file.remove(FILES)
### write second part of Fields 
FILES <- list.files(path = paste0(getwd(),"/Fields2/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  colnames(FILE)[1] <- "L"
  FILE$L <- sprintf("%2d",as.integer(FILE$L))
  FILE$...........XCRD <- sprintf("%15.3f",FILE$...........XCRD)
  FILE$...........YCRD <- sprintf("%15.3f",FILE$...........YCRD)
  FILE$.....ELEV <- sprintf("%9d",as.integer(FILE$.....ELEV))
  FILE$.............AREA <- sprintf("%17d",as.integer(FILE$.............AREA))
  FILE$.SLEN <- sprintf("%5d",as.integer(FILE$.SLEN))
  FILE$.FLWR <- sprintf("%5d",as.integer(FILE$.FLWR))
  FILE$.SLAS <- sprintf("%5d",as.integer(FILE$.SLAS))
  FILE$FLHST <- sprintf("%5d",as.integer(FILE$FLHST))
  FILE$FHDUR <- sprintf("%5d",as.integer(FILE$FHDUR))
  colnames(FILE)[1] <- "@L"
  #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
file.remove(FILES)

### Pate the header and dataframes 
genmodeldats <- function(inputfold,inputfold1,header,outdir){
  # Find common filenames in each folder
  filex <- tools::file_path_sans_ext(list.files(inputfold,pattern = "^.*\\.txt$"))
  # second part of fields
  filex1 <- tools::file_path_sans_ext(list.files(inputfold1,pattern = "^.*\\.txt$"))
  commonf <- Reduce(base::intersect,list(filex))
  # Now append all these files and write to outdir
  for(f in commonf){
    # New file name
    modeldat <- file.path(outdir,paste0(f,".txt"))
    #path for spliited filex
    filex1 <- file.path(inputfold,paste0(f,".txt"))
    filex2 <- file.path(inputfold1,paste0(f,".txt"))
    cat("",file=modeldat,append=FALSE)
    for(i in c(header,filex1,filex2)){
      file.append(modeldat,i)
    }
    message("Filex written written to ",modeldat)
  }
}
genmodeldats(paste0(getwd(),"/Fields1/"),paste0(getwd(),"/Fields2/"),header = "hdr.txt",paste0(getwd(),"/Fields"))

unlink("Fields1",recursive = T)
unlink("Fields2",recursive = T)
file.remove("hdr.txt")


####