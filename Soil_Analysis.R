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
sheet <- read_excel(FILEX,sheet = "Soil_Analysis")
## select columns for second part of IC
sheet_1 <- sheet[,c(1,2,9:ncol(sheet))]
#reshaping the second part for keeping all the depths in same columnn
sheet_2 <- melt(data = sheet_1,id.vars = c("Name","A"))

##split names
n1 <- gsub("[[:digit:]]","",sheet_2$variable)
n2 <- gsub("[[:alpha:]]","",sheet_2$variable)
sheet_2$variable <- paste0(n1,"_",n2)

## split name by _
sheet_3 <- data.frame(do.call('rbind', strsplit(as.character(sheet_2$variable),'_',fixed=TRUE)))
sheet_2$variable <- sheet_3$X1
##REmove NA values rows
sheet_2[sheet_2=="NA"] <- NA
sheet_f <- na.omit(sheet_2)
names(sheet_f) <- c("Name" ,"A" ,"variable","value")
## reshaping wide again to split at every station
sheet_f$samples <- rownames(sheet_f)
sheet_4 <- spread(sheet_f,variable,value)
#sheet_4 <- reshape(sheet_f,timevar = "variable",idvar = c("Name","A","samples"),direction = "wide")

### removing na values from one by one column 
SABL <- na.omit(sheet_4[,c(1,2,4)])
SADM <- na.omit(sheet_4[,c(1,2,5)])
SAOC <- na.omit(sheet_4[,c(1,2,8)])
SANI <- na.omit(sheet_4[,c(1,2,7)])
SAPHW <- na.omit(sheet_4[,c(1,2,10)])
SAPHB <- na.omit(sheet_4[,c(1,2,9)])
SAPX <- na.omit(sheet_4[,c(1,2,11)])
SAKE <- na.omit(sheet_4[,c(1,2,6)])
SASC <- na.omit(sheet_4[,c(1,2,12)])

##cbind all columns
sheet_5 <- cbind(SABL[,1:3],SADM[,3],SAOC[,3],SANI[,3],SAPHW[,3],SAPHB[,3],SAPX[,3],SAKE[,3],SASC[,3])

names(sheet_5) <- c("Name","A","SABL","SADM","SAOC","SANI","SAPHW","SAPHB","SAPX","SAKE","SASC")

## split sheet intoi multiple dat frames for creating mutple filex files
sheet$Name_A <- paste0(sheet$Name,"_",sheet$A)
dfs <- split(sheet[c(2,4:8)],sheet$Name_A)
sheet_5$Name_A = paste0(sheet_5$Name,"_",sheet_5$A)
dfs1 <- split(sheet_5[2:(ncol(sheet_5)-1)],sheet_5$Name_A)
##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"SA1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"SA2"),showWarnings = FALSE)
dir.create(file.path(getwd(),"SA3"),showWarnings = FALSE)
dir.create(file.path(getwd(),"SA4"),showWarnings = FALSE)
dir.create(file.path(getwd(),"SA"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/SA1/",i,".csv"),row.names = F)
}

for (i in names(dfs1)){
  write.csv(dfs1[[i]],paste0(getwd(),"/SA2/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/SA1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  hdr <- "*SOIL ANALYSIS"
  write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
  colnames(FILE)[1] <- "A"
  #FILE$SADAT <- paste0("0",FILE$SADAT)
  FILE$A <- sprintf("%2d",as.integer(FILE$A))
   FILE$SADAT <- sprintf("%5s",FILE$SADAT)
   FILE$SMHB <- sprintf("%5s",FILE$SMHB)
   FILE$SMPX <- sprintf("%5s",FILE$SMPX)
   FILE$SMKE <- sprintf("%5s",FILE$SMKE)
   FILE$SANAME <- sprintf("%-12s",FILE$SANAME)
   colnames(FILE)[1] <- "@A"
   write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}

FILES <- list.files(path = paste0(getwd(),"/SA2/"),pattern=".csv$",full.names = T)

for (i in 1:length(FILES)) {
   FILE=read.csv(file=FILES[i])
   colnames(FILE)[1] <- "A"
   FILE$A <- sprintf("%2d",as.integer(FILE$A))
   FILE$SABL <- sprintf("%5s",FILE$SABL)
   FILE$SADM <- sprintf("%5s",FILE$SADM)
   FILE$SAOC <- sprintf("%5s",FILE$SAOC)
   FILE$SANI <- sprintf("%5s",FILE$SANI)
   FILE$SAPHW <- sprintf("%5s",FILE$SAPHW)
   FILE$SAPHB <- sprintf("%5s",FILE$SAPHB)
   FILE$SAPX <- sprintf("%5s",FILE$SAPX)
   FILE$SAKE <- sprintf("%5s",FILE$SAKE)
   FILE$SASC <- sprintf("%5s",FILE$SASC)
   colnames(FILE)[1] <- "@A"
    write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}

 
genmodeldats <- function(inputfold,inputfold1,outdir){
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
    for(i in c(filex1,filex2)){
      file.append(modeldat,i)
    }
    message("Filex written written to ",modeldat)
  }
}
genmodeldats(paste0(getwd(),"/SA1/"),paste0(getwd(),"/SA2/"),paste0(getwd(),"/SA3"))

n <- round(nrow(sheet)/99)
#reading alll the files by segaments
for (i in 1:n){
  myfiles = list.files(path=paste0(getwd(),"/SA3/"),pattern = paste0(paste0("MAIZ",str_pad(i,4,pad = "0"),"_")),full.names = T)
  ##reading all the files through lapply
  list_files <- lapply(myfiles,function(x) read.table(x,fill=T,stringsAsFactors=F,header = F))
  #appenmding all the groups into master file
   master_file <- do.call(rbind,list_files)
  # #assiging the widhths to the master file 
   master_file$V1 <- sprintf("%2s",master_file$V1)
  master_file$V2 <- sprintf("%5s",master_file$V2)
  master_file$V3 <- sprintf("%5s",master_file$V3)
  master_file$V4 <- sprintf("%5s",master_file$V4)
  master_file$V5 <- sprintf("%5s",master_file$V5)
  master_file$V6 <- sprintf("%5s",master_file$V6)
  master_file$V7 <- sprintf("%5s",master_file$V7)
  master_file$V8 <- sprintf("%5s",master_file$V8)
  master_file$V9 <- sprintf("%5s",master_file$V9)
  master_file$V10 <- sprintf("%-12s",master_file$V10)
  # ## write the master files into segments 
   write.table(master_file,paste0(paste0(getwd(),"/SA4/"),"MAIZ",str_pad(i,4,pad = "0"),".txt"),row.names = F,col.names = F,quote = F)
}

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
genmodeldats(paste0(getwd(),"/SA4/"),header = "hdr.txt",paste0(getwd(),"/SA/"))

unlink("SA1",recursive = T)
unlink("SA2",recursive = T)
unlink("SA3",recursive = T)
unlink("SA4",recursive = T)
file.remove("hdr.txt")

####
