# Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_181/")
# options(java.parameters = "-Xmx4g")
library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
##setwd and path Major FILEX path
# start_y <- "2002"
# y1 <- as.Date(start_y,"%Y")
# y2 <- format(y1,"%y")
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
FILEX <- "C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/DSSAT_KARNATAK/FILEX_DSSAT.xlsx"

### Read write and treatments in DSSAT Part
sheet <- read_excel(FILEX,sheet = "Fertilizers_Organic")
## split sheet intoi multiple dat frames for creating mutple filex files
sheet_1 <- sheet[,c(1,2,4:ncol(sheet))]
#reshaping the second part for keeping all the depths in same columnn
sheet_2 <- melt(data = sheet_1,id.vars = c("Name","R"))
## split name by _
n1 <- gsub("[[:digit:]]","",sheet_2$variable)
n2 <- gsub("[[:alpha:]]","",sheet_2$variable)
sheet_2$variable <- paste0(n1,"_",n2)
sheet_3 <- data.frame(do.call('rbind', strsplit(as.character(sheet_2$variable),'_',fixed=TRUE)))
sheet_2$variable <- sheet_3$X1
##REmove NA values rows
sheet_2[sheet_2=="NA"] <- NA
sheet_f <- na.omit(sheet_2)
names(sheet_f) <- c("Name","R" ,"variable","value")
## reshaping wide again to split at every station
sheet_f$samples <- rownames(sheet_f)
sheet_4 <- spread(sheet_f,variable,value)


### removing na values from one by one column 
RDATE <- na.omit(sheet_4[,c(1,2,6)])
RCOD <- na.omit(sheet_4[,c(1,2,5)])
RAMT <- na.omit(sheet_4[,c(1,2,4)])
RESN <- na.omit(sheet_4[,c(1,2,10)])
RESP <- na.omit(sheet_4[,c(1,2,11)])
RESK <- na.omit(sheet_4[,c(1,2,9)])
RINP <- na.omit(sheet_4[,c(1,2,12)])
RDEP <- na.omit(sheet_4[,c(1,2,7)])
RMET <- na.omit(sheet_4[,c(1,2,13)])
RENAME <- na.omit(sheet_4[,c(1,2,8)])
#FERNAME <- na.omit(sheet_4[,c(1,2,12)])

##cbind all columns
sheet_5 <- cbind(RDATE[,1:3],RCOD[,3],RAMT[,3],RESN[,3],RESP[,3],RESK[,3],RINP[,3],RDEP[,3],RMET[,3],RENAME[,3])
#sheet_5$RDATE <- paste0(y2,sprintf("%03d",as.numeric(sheet_5$RDATE)))
names(sheet_5) <- c("Name","@F","RDATE","RCOD","RAMT","RESN","RESP","RESK","RINP","RDEP","RMET","RENAME")

## split sheet intoi multiple dat frames for creating mutple filex files
dfs <- split(sheet_5[2:ncol(sheet_5)],sheet_5$Name)

##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"RR1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"RR"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/RR1/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/RR1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  colnames(FILE)[1] <- "R"
  FILE$R <-  sprintf("%2d",as.integer(FILE$R))
  FILE$RDATE <- sprintf("%5d",as.integer(FILE$RDATE))
  FILE$RCOD <- sprintf("%5s",FILE$RCOD)
  FILE$RAMT <- sprintf("%5d",as.integer(FILE$RAMT))
  FILE$RESN <- sprintf("%5d",FILE$RESN)
  FILE$RESP <- sprintf("%5d",as.integer(FILE$RESP))
  FILE$RESK <- sprintf("%5d",as.integer(FILE$RESK))
  FILE$RINP <- sprintf("%5d",as.integer(FILE$RINP))
  FILE$RDEP <- sprintf("%5d",as.integer(FILE$RDEP))
  FILE$RMET <- sprintf("%5s",FILE$RMET)
  FILE$RENAME <- sprintf("%-12s",FILE$RENAME)
  colnames(FILE)[1] <- "@R"
  hdr <- "*RESIDUES AND ORGANIC FERTILIZER"
  write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
  #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,1:ncol(FILE)]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)

}
#file.remove(FILES)

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
genmodeldats(paste0(getwd(),"/RR1/"),header = "hdr.txt",paste0(getwd(),"/RR"))
## removing the old files 
file.remove("hdr.txt")
unlink("RR1",recursive = T)




####