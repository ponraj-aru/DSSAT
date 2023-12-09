# Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_181/")
# options(java.parameters = "-Xmx4g")
library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
library(reshape2)
library(tidyr)
options(warn=-1)

##setwd and path Major FILEX path
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
FILEX <- "C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/DSSAT_KARNATAK/FILEX_DSSAT.xlsx"

### Read write and treatments in DSSAT Part
sheet <- read_excel(FILEX,sheet = "Initial_Conditions")
## select columns for second part of IC
sheet_1 <- sheet[,c(1,16:ncol(sheet))]
#reshaping the second part for keeping all the depths in same columnn
sheet_2 <- melt(data = sheet_1,id.vars = c("Name","Location","@C...17"))
## split name by _
sheet_3 <- data.frame(do.call('rbind', strsplit(as.character(sheet_2$variable),'_',fixed=TRUE)))
sheet_2$variable <- sheet_3$X1
##REmove NA values rows
sheet_2[sheet_2=="NA"] <- NA
sheet_f <- na.omit(sheet_2)
names(sheet_f) <- c("Name" ,"Location","C" ,"variable","value")
## reshaping wide again to split at every station
sheet_f$samples <- rownames(sheet_f)
sheet_4 <- spread(sheet_f,variable,value)

### removing na values from one by one column 
ICBL <- na.omit(sheet_4[,c(1,3,5)])
SH2O <- na.omit(sheet_4[,c(1,3,6)])
SNH4 <- na.omit(sheet_4[,c(1,3,7)])
SNO3 <- na.omit(sheet_4[,c(1,3,8)])

##cbind all columns
sheet_5 <- cbind(ICBL[,1:3],SH2O[,3],SNH4[,3],SNO3[,3])

names(sheet_5) <- c("Name","@C","ICBL","SH2O","SNH4","SNO3")

## split sheet intoi multiple dat frames for creating mutple filex files
dfs <- split(sheet[2:15],sheet$Name)
dfs1 <- split(sheet_5[2:ncol(sheet_5)],sheet_5$Name)
##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"IC1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"IC2"),showWarnings = FALSE)
dir.create(file.path(getwd(),"IC"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/IC1/",i,".csv"),row.names = F)
}

for (i in names(dfs1)){
  write.csv(dfs1[[i]],paste0(getwd(),"/IC2/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/IC1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  colnames(FILE)[1] <- "C"
  hdr <- "*INITIAL CONDITIONS"
  write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
  
  #FILE$ICDAT <- paste0("0",FILE$ICDAT)
  FILE$C <- sprintf("%2d",as.integer(FILE$C))
  FILE$PCR <- sprintf("%5s",FILE$PCR)
  FILE$ICDAT <- sprintf("%5s",FILE$ICDAT)
  FILE$ICRT <- sprintf("%5d",as.integer(FILE$ICRT))
  FILE$ICND <- sprintf("%5d",as.integer(FILE$ICND))
  FILE$ICRN <- sprintf("%5d",as.integer(FILE$ICRN))
  FILE$ICRE <- sprintf("%5d",as.integer(FILE$ICRE))
  FILE$ICWD <- sprintf("%5d",as.integer(FILE$ICWD))
  FILE$ICRES <- sprintf("%5d",as.integer(FILE$ICRES))
  FILE$ICREN <- sprintf("%5d",as.integer(FILE$ICREN))
  FILE$ICREP <- sprintf("%5d",as.integer(FILE$ICREP))
  FILE$ICRIP <- sprintf("%5d",as.integer(FILE$ICRIP))
  FILE$ICRID <- sprintf("%5d",as.integer(FILE$ICRID))
  FILE$ICNAME <- sprintf("%-12s",FILE$ICRT)

  colnames(FILE)[1] <- "@C"
  
  #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,1:ncol(FILE)]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
file.remove(FILES)

### write second part of Fields 
FILES <- list.files(path = paste0(getwd(),"/IC2/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
   colnames(FILE)[1] <- "C"
    FILE$C <- sprintf("%2d",as.integer(FILE$C))
    FILE$ICBL <- sprintf("%5.2f",FILE$ICBL)
    FILE$SH2O <- sprintf("%5.2f",FILE$SH2O)
   FILE$SNH4 <- sprintf("%5.2f",FILE$SNH4)
   FILE$SNO3 <- sprintf("%5.2f",FILE$SNO3)
   colnames(FILE)[1] <- "@C"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
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
genmodeldats(paste0(getwd(),"/IC1/"),paste0(getwd(),"/IC2/"),header = "hdr.txt",paste0(getwd(),"/IC"))

unlink("IC1",recursive = T)
unlink("IC2",recursive = T)
file.remove("hdr.txt")


####