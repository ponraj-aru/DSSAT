library(plyr)
library(readxl)
library(stringi)
library(stringr)
library(R.matlab)
  # Find common filenames in each folder
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
dir.create(file.path(getwd(),"IR1"),showWarnings = FALSE)
#read the filex excel sheet to count the rows
FILEX <- "C:/Users/arumu002/OneDrive - Wageningen University & Research/Project I/Data/BAF/FILEX_DSSAT.xlsx"
sheet <- read_excel(FILEX,sheet = "Irrigation_WM")
#nrow to calculate the files to through in loop to read all the files by name
n <- round(nrow(sheet)/99)+1
#reading alll the files by segaments
for (i in 1:n){
  myfiles = list.files(pattern = paste0(paste0("RICE",str_pad(i,4,pad = "0"),"."),"*.txt$"))
  ##reading all the files through lapply
  list_files <- lapply(myfiles,function(x) read.table(x,fill=T,stringsAsFactors=F,header = F))
  #appenmding all the groups into master file
  master_file <- do.call(rbind,list_files)
  #assiging the widhths to the master file 
  master_file$V1 <- sprintf("%2s",master_file$V1)
  master_file$V2 <- sprintf("%5s",master_file$V2)
  master_file$V3 <- sprintf("%5s",master_file$V3)
  master_file$V4 <- sprintf("%5s",master_file$V4)
  master_file$V5 <- sprintf("%5s",master_file$V5)
  master_file$V6 <- sprintf("%5s",master_file$V6)
  master_file$V7 <- sprintf("%5s",master_file$V7)
  master_file$V8 <- sprintf("%5s",master_file$V8)
  master_file$V9 <- sprintf("%12s",master_file$V9)
  ## write the master files into segments 
  write.table(master_file,paste0(paste0(getwd(),"/IR1/"),"RICE",str_pad(i,4,pad = "0"),".txt"),row.names = F,col.names = F,quote = F)
}
    
