# Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_181/")
# options(java.parameters = "-Xmx4g")
library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
library(reshape2)
library(tidyr)
library(gtools)
options(warn=-1)
###mentioninf the year generating dates
# start_y <- "2002"
# y1 <- as.Date(start_y,"%Y")
# y2 <- format(y1,"%y")
##setwd and path Major FILEX path
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
FILEX <- "C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/DSSAT_KARNATAK/FILEX_DSSAT.xlsx"

### Read write and treatments in DSSAT Part
sheet <- read_excel(FILEX,sheet = "Irrigation_WM")
## select columns for second part of IC
sheet_1 <- sheet[,c(1,3,12:ncol(sheet))]
#reshaping the second part for keeping all the depths in same columnn
sheet_2 <- melt(data = sheet_1,id.vars = c("Name","I"))

##split names
n1 <- gsub("[[:digit:]]","",sheet_2$variable)
n2 <- gsub("[[:alpha:]]","",sheet_2$variable)
sheet_2$variable <- paste0(n1,"_",n2)

sheet_3 <- data.frame(do.call('rbind', strsplit(as.character(sheet_2$variable),'_',fixed=TRUE)))
sheet_2$variable <- sheet_3$X1
##REmove NA values rows
sheet_2[sheet_2=="NA"] <- NA
sheet_f <- na.omit(sheet_2)
names(sheet_f) <- c("Name","I" ,"variable","value")
## reshaping wide again to split at every station
sheet_f$samples <- rownames(sheet_f)
sheet_4 <- spread(sheet_f,variable,value)
#sheet_4 <- reshape(sheet_f,timevar = "variable",idvar = c("Name","I","samples"),direction = "wide")
### removing na values from one by one column 
t <- na.omit(sheet_4)
IDATE <- na.omit(sheet_4[,c(1:2,4)])
IROP <- na.omit(sheet_4[,c(1:2,5)])
IRVAL <- na.omit(sheet_4[,c(1,2,6)])


##cbind all columns
sheet_5 <- cbind(IDATE,IROP[,3],IRVAL[,3])
#sheet_5$IDATE <- paste0(y2,sprintf("%03d",as.numeric(sheet_5$IDATE)))
names(sheet_5) <- c("Name","I","IDATE","IROP","IRVAL")
sheet_5$Name_I = paste0(sheet_5$Name,"_",sheet_5$I)

## split sheet intoi multiple dat frames for creating mutple filex files
sheet$Name_I <- paste0(sheet$Name,"_",sheet$I)
df <- split(sheet[3:11],sheet$Name_I)
dfs <- df[1:nrow(sheet)]
dfs1 <- split(sheet_5[2:(ncol(sheet_5)-1)],sheet_5$Name_I)
#dfs1 <- lapply(df1, function(df){df[order(df$Name_I),]})


#dfs1 <- df1[1:nrow(sheet_5)]
##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"IR1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"IR2"),showWarnings = FALSE)
dir.create(file.path(getwd(),"IR3"),showWarnings = FALSE)
dir.create(file.path(getwd(),"IR4"),showWarnings = FALSE)
dir.create(file.path(getwd(),"IR"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/IR1/",i,".csv"),row.names = F)
}

for (i in names(dfs1)){
  write.csv(dfs1[[i]],paste0(getwd(),"/IR2/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/IR1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  colnames(FILE)[1] <- "I"
  hdr <- "*IRRIGATION AND WATER MANAGEMENT"
  write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
  FILE$I <- sprintf("%2d",as.integer(FILE$I))
  FILE$EFIR <- sprintf("%5d",as.integer(FILE$EFIR))
  FILE$IDEP <- sprintf("%5d",as.integer(FILE$IDEP))
  FILE$ITHR <- sprintf("%5d",as.integer(FILE$ITHR))
  FILE$IEPT <- sprintf("%5d",as.integer(FILE$IEPT))
  FILE$IOFF <- sprintf("%5s",FILE$IOFF)
  FILE$IAME <- sprintf("%5s",FILE$IAME)
  FILE$IAMT <- sprintf("%5d",as.integer(FILE$IAMT))
  FILE$IRNAME <- sprintf("%12s",FILE$IRNAME)
  colnames(FILE)[1] <- "@I"
  #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,1:ncol(FILE)]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
#file.remove(FILES)

### write second part of Fields 
FILES <- list.files(path = paste0(getwd(),"/IR2/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  FILE$IDATE <- paste0("0", FILE$IDATE)
  colnames(FILE)[1] <- "I"
  FILE$I <- sprintf("%2d",as.integer(FILE$I))
  FILE$IDATE <- sprintf("%5d",as.integer(FILE$IDATE))
  FILE$IROP <- sprintf("%5s",FILE$IROP)
  FILE$IRVAL <- sprintf("%5d",as.integer(FILE$IRVAL))
  colnames(FILE)[1] <- "@I"
  #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
#file.remove(FILES)

### Pate the header and dataframes 
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
    #path for s pliited filex
    filex1 <- file.path(inputfold,paste0(f,".txt"))
    filex2 <- file.path(inputfold1,paste0(f,".txt"))
    cat("",file=modeldat,append=FALSE)
    for(i in c(filex1,filex2)){
      file.append(modeldat,i)
    }
    message("Filex written written to ",modeldat)
  }
}
genmodeldats(paste0(getwd(),"/IR1/"),paste0(getwd(),"/IR2/"),paste0(getwd(),"/IR3"))

n <- round(nrow(sheet)/99)

#reading alll the files by segaments
for (i in 1:n){
  myfiles = list.files(path=paste0(getwd(),"/IR3/"),pattern = paste0(paste0("MAIZ",str_pad(i,4,pad = "0"),"_")),full.names = T)
  ##reading all the files through lapply
  list_files1 <- lapply(mixedsort(sort(myfiles)),function(x) read.table(x,fill=T,stringsAsFactors=F,header = F))
  #appenmding all the groups into master file
  master_file <- do.call(rbind,list_files1)
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
  write.table(master_file,paste0(paste0(getwd(),"/IR4/"),"MAIZ",str_pad(i,4,pad = "0"),".txt"),row.names = F,col.names = F,quote = F)
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
genmodeldats(paste0(getwd(),"/IR4/"),header = "hdr.txt",paste0(getwd(),"/IR/"))

unlink("IR1",recursive = T)
unlink("IR2",recursive = T)
unlink("IR3",recursive = T)
unlink("IR4",recursive = T)
file.remove("hdr.txt")


####
