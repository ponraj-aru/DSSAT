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
sheet <- read_excel(FILEX,sheet = "Automate_Management")
sheet[is.na(sheet)] <- " "
## read sheets one by one categories 
sheet_a <- sheet[,c(1,3:11)]
sheet_b <- unique(sheet_a)
## split sheet intoi multiple dat frames for creating mutple filex files
colnames(sheet)[3] <- "N"
sheet$Name_A <- paste0(sheet$Name,"_",sheet$N)
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"Ama1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Ama2"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Ama3"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Ama4"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Ama5"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Ama6"),showWarnings = FALSE)
#dir.create(file.path(getwd(),"Ama"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Ama1/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Ama1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  FILE[is.na(FILE)] <- " "
  colnames(FILE)[1] <- "N"
  hdr <- "@  AUTOMATIC MANAGEMENT"
  write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
  FILE$N <- sprintf("%2d",as.integer(FILE$N))
  FILE$PLANTING <- sprintf("%-11s",FILE$PLANTING)
  FILE$PFRST <- sprintf("%5s",FILE$PFRST)#,paste0("0",FILE$PLAST)
  FILE$PLAST <- sprintf("%5s",FILE$PLAST)#,paste0("0",FILE$PLAST)
  FILE$PH2OL <- sprintf("%5d",as.integer(FILE$PH2OL))
  FILE$PH2OU <- sprintf("%5d",as.integer(FILE$PH2OU))
  FILE$PH2OD <- sprintf("%5d",as.integer(FILE$PH2OD))
  FILE$PSTMX <- sprintf("%5d",as.integer(FILE$PSTMX))
  FILE$PSTMN <- sprintf("%5d",as.integer(FILE$PSTMN))
  # 
  colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
#file.remove(FILES)
### Second option
sheet_a <- sheet[,c(1,12:20)]
sheet_b <- unique(sheet_a)
#split data farme
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Ama2/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Ama2/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  FILE[is.na(FILE)] <- " "
  colnames(FILE)[1] <- "N"
   FILE$N <- sprintf("%2d",as.integer(FILE$N))
   FILE$IRRIGATION <- sprintf("%-11s",FILE$IRRIGATION)
   FILE$IMDEP <- sprintf("%5d",as.integer(FILE$IMDEP))
   FILE$ITHRL <- sprintf("%5d",as.integer(FILE$ITHRL))
   FILE$ITHRU <- sprintf("%5d",as.integer(FILE$ITHRU))
   FILE$IROFF <- sprintf("%5s",FILE$IROFF)
   FILE$IMETH <- sprintf("%5s",FILE$IMETH)
   FILE$IRAMT <- sprintf("%5d",as.integer(FILE$IRAMT))
   FILE$IREFF <- sprintf("%5d",as.integer(FILE$IREFF))
  # 
  colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}

### tHIRD option
sheet_a <- sheet[,c(1,21:27)]
sheet_b <- unique(sheet_a)
#split data farme
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Ama3/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Ama3/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  FILE[is.na(FILE)] <- " "
  colnames(FILE)[1] <- "N"
   FILE$N <- sprintf("%2d",as.integer(FILE$N))
   FILE$NITROGEN <- sprintf("%-11s",FILE$NITROGEN)
   FILE$NMDEP <- sprintf("%5d",as.integer(FILE$NMDEP))
   FILE$NMTHR <- sprintf("%5d",as.integer(FILE$NMTHR))
   FILE$NAMNT <- sprintf("%5d",as.integer(FILE$NAMNT))
   FILE$NCODE <- sprintf("%5s",FILE$NCODE)
   FILE$NAOFF <- sprintf("%5s",FILE$NAOFF)
   
  colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}

##fourth option
sheet_a <- sheet[,c(1,28:32)]
sheet_b <- unique(sheet_a)
#split data farme
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Ama4/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Ama4/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  FILE[is.na(FILE)] <- " "
  colnames(FILE)[1] <- "N"
  FILE$N <- sprintf("%2d",as.integer(FILE$N))
   FILE$RESIDUES <- sprintf("%-11s",FILE$RESIDUES)
   FILE$RIPCN <- sprintf("%5d",as.integer(FILE$RIPCN))
   FILE$RTIME <- sprintf("%5d",as.integer(FILE$RTIME))
   FILE$RIDEP <- sprintf("%5d",as.integer(FILE$RIDEP))
   colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}

sheet_a <- sheet[,c(1,33:(ncol(sheet)-1))]
sheet_b <- unique(sheet_a)
#split data farme
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Ama5/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Ama5/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  FILE[is.na(FILE)] <- " "
  colnames(FILE)[1] <- "N"
   FILE$N <- sprintf("%2d",as.integer(FILE$N))
   FILE$HARVEST <- sprintf("%-11s",FILE$HARVEST)
   FILE$HFRST <- sprintf("%5d",as.integer(FILE$HFRST))
   FILE$HLAST <- sprintf("%5s",paste0("0",FILE$HLAST))
   FILE$HPCNP <- sprintf("%5d",as.integer(FILE$HPCNP))
   FILE$HPCNR <- sprintf("%5d",as.integer(FILE$HPCNR))
   colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
### Pate the header and dataframes 
genmodeldats <- function(inputfold1,inputfold2,inputfold3,inputfold4,inputfold5,header,outdir){
  # Find common filenames in each folder
  filex1 <- tools::file_path_sans_ext(list.files(inputfold1,pattern = "^.*\\.txt$"))
  filex2 <- tools::file_path_sans_ext(list.files(inputfold2,pattern = "^.*\\.txt$"))
  filex3 <- tools::file_path_sans_ext(list.files(inputfold3,pattern = "^.*\\.txt$"))
  filex4 <- tools::file_path_sans_ext(list.files(inputfold4,pattern = "^.*\\.txt$"))
  filex5 <- tools::file_path_sans_ext(list.files(inputfold5,pattern = "^.*\\.txt$"))
  # switchf <- tools::file_path_sans_ext(list.files(switchfold,pattern = "^.*\\.DAT$"))
  commonf <- Reduce(base::intersect,list(filex1))
  # Now append all these files and write to outdir
  for(f in commonf){
    # New file name
    modeldat <- file.path(outdir,paste0(f,".txt"))
    #path for spliited filex
    filex1 <- file.path(inputfold1,paste0(f,".txt"))
    filex2 <- file.path(inputfold2,paste0(f,".txt"))
    filex3 <- file.path(inputfold3,paste0(f,".txt"))
    filex4 <- file.path(inputfold4,paste0(f,".txt"))
    filex5 <- file.path(inputfold5,paste0(f,".txt"))
    
    cat("",file=modeldat,append=FALSE)
    for(i in c(header,filex1,filex2,filex3,filex4,filex5)){
      file.append(modeldat,i)
    }
    message("Filex written written to ",modeldat)
  }
}
genmodeldats(paste0(getwd(),"/Ama1/"),paste0(getwd(),"/Ama2/"),paste0(getwd(),"/Ama3/"),paste0(getwd(),"/Ama4/"),paste0(getwd(),"/Ama5/"),
             header = "hdr.txt",paste0(getwd(),"/Ama6"))

unlink("Ama1",recursive = T)
unlink("Ama2",recursive = T)
unlink("Ama3",recursive = T)
unlink("Ama4",recursive = T)
unlink("Ama5",recursive = T)
file.remove("hdr.txt")

# genmodeldats <- function(inputfold1,outdir){
#   nf <- substr(tools::file_path_sans_ext(list.files(inputfold1,pattern = "^.*\\.txt$")),1,8)
#   commonf <- Reduce(base::intersect,list(unique(nf)))
#   for(f in commonf){
#     # New file name
#     modeldat <- file.path(outdir,paste0(f,".txt"))
#     #path for spliited filex
#     filex1 <-  mixedsort(sort(list.files(inputfold1,pattern = paste0(paste0(f),".*txt"),full.names = T)))
#     # filex2 <- file.path(inputfold2,paste0(f,".txt"))
#     # filex3 <- file.path(inputfold3,paste0(f,".txt"))
#     # filex4 <- file.path(inputfold4,paste0(f,".txt"))
#     # filex5 <- file.path(inputfold5,paste0(f,".txt"))
#     
#     cat("",file=modeldat,append=FALSE)
#     for(i in c(filex1)){
#       file.append(modeldat,i)
#     }
#     message("Filex written written to ",modeldat)
#   }
# }
# 
# genmodeldats(inputfold1 = "C:/Users/ponraj/Desktop/filex/Ama6/","C:/Users/ponraj/Desktop/filex/Ama//")
# 
# unlink("Ama6",recursive = T)
####