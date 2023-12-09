library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
##setwd and path Major FILEX path
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
FILEX <- "C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/DSSAT_KARNATAK/FILEX_DSSAT.xlsx"

### Read write and treatments in DSSAT Part
sheet <- read_excel(FILEX,sheet = "FILEX")
dfs <- split(sheet[2:ncol(sheet)],sheet$State)

dir.create(file.path(getwd(),"FILEX1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"FILEX"),showWarnings = FALSE)

for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/FILEX1/",i,".csv"),row.names = F)
}

FILES <- list.files(path = paste0(getwd(),"/FILEX1/"),pattern="*.csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  #colnames(FILE)[1] <- "L"
  hdr <- "$BATCH (RICE)"
  write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
FILE$FILEX <- sprintf("%6s",FILE$FILEX)
FILE$TRTNO <- sprintf("%40s",FILE$TRTNO)
FILE$RP <- sprintf("%6i",FILE$RP)
FILE$SQ <- sprintf("%6i",FILE$SQ)
FILE$OP <- sprintf("%6i",FILE$OP)
FILE$CO <- sprintf("%6i",FILE$CO)
colnames(FILE) <- c("@FILEX","TRTNO","RP","SQ","OP","CO")
write.table(sheet,"Trts.txt",quote = F,row.names = F,col.names = F)

write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}

genmodeldats <- function(inputfold,header,outdir){
  # Find common filenames in each folder
  filex <- tools::file_path_sans_ext(list.files(inputfold,pattern = "^.*\\.txt$"))
  # second part of fields
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
genmodeldats(paste0(getwd(),"/FILEX1/"),header = "hdr.txt",paste0(getwd(),"/FILEX"))

files <- list.files(paste0(getwd(),"/FILEX/"),pattern = "*.txt",full.names = T) 
sapply(files,FUN=function(eachPath){ 
  file.rename(from=eachPath,to= sub(pattern=".txt", paste0(".v47"),eachPath))
})

unlink("FILEX1",recursive = T)
#unlink("Fields2",recursive = T)
file.remove("hdr.txt")


####3
sheet <- read_excel(FILEX,sheet="FILEX")
FILE <- sheet[,2:ncol(sheet)]
FILE$FILEX <- sprintf("%6s",FILE$FILEX)
FILE$TRTNO <- sprintf("%48s",FILE$TRTNO)
FILE$RP <- sprintf("%6i",FILE$RP)
FILE$SQ <- sprintf("%6i",FILE$SQ)
FILE$OP <- sprintf("%6i",FILE$OP)
FILE$CO <- sprintf("%6i",FILE$CO)
colnames(FILE) <- c("@FILEX","TRTNO","RP","SQ","OP","CO")
#write.table(sheet,"Trts.txt",quote = F,row.names = F,col.names = F)

write.table(FILE,file="DSSBAtch1.v47",row.names = F,col.names = T,quote = F)
