# Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_181/")
# options(java.parameters = "-Xmx4g")
library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
library(gtools)
##setwd and path Major FILEX path
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
FILEX <- "C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/DSSAT_KARNATAK/FILEX_DSSAT.xlsx"

### Read write and treatments in DSSAT Part
sheet <- read_excel(FILEX,sheet = "Simulation_Control")
sheet[is.na(sheet)] <- " "
## read sheets one by one categories 
sheet_a <- sheet[,c(1,3:11)]
sheet_b <- unique(sheet_a)
## split sheet intoi multiple dat frames for creating mutple filex files
colnames(sheet)[3] <- "N"
sheet$Name_A <- paste0(sheet$Name,"_",sheet$N)
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
##creat directory for saving multple filex treat ments
dir.create(file.path(getwd(),"Sim1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Sim2"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Sim3"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Sim4"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Sim5"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Sim6"),showWarnings = FALSE)
#dir.create(file.path(getwd(),"Sim"),showWarnings = FALSE)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Sim1/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Sim1/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
   FILE=read.csv(file=FILES[i])
   FILE[is.na(FILE)] <- " "
   colnames(FILE)[1] <- "N"
   hdr <- "*SIMULATION CONTROLS"
   write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
            colnames = F)
   FILE$N <- sprintf("%2d",as.integer(FILE$N))
   FILE$GENERAL <- sprintf("%-11s",FILE$GENERAL)
   FILE$NYERS <- sprintf("%5d",as.integer(FILE$NYERS))
   FILE$NREPS <- sprintf("%5d",as.integer(FILE$NREPS))
   FILE$START <- sprintf("%5s",FILE$START)
   FILE$SDATE <- sprintf("%5s",FILE$SDATE)#,paste0("0",FILE$SDATE)
   FILE$RSEED <- sprintf("%5d",as.integer(FILE$RSEED))
   FILE$SNAME.................... <- sprintf("%-25s",FILE$SNAME....................)
   FILE$SMODEL <- sprintf("%-6s",FILE$SMODEL)
   colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
   write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
#file.remove(FILES)
### Second option
sheet_a <- sheet[,c(1,12:22)]
sheet_b <- unique(sheet_a)
#split data farme
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Sim2/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Sim2/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  FILE[is.na(FILE)] <- " "
  colnames(FILE)[1] <- "N"
    FILE$N <- sprintf("%2d",as.integer(FILE$N))
    FILE$OPTIONS <- sprintf("%-11s",FILE$OPTIONS)
   FILE$WATER <- sprintf("%5s",FILE$WATER)
   FILE$NITRO <- sprintf("%5s",FILE$NITRO)
   FILE$SYMBI <- sprintf("%5s",FILE$SYMBI)
   FILE$PHOSP <- sprintf("%5s",FILE$PHOSP)
   FILE$POTAS <- sprintf("%5s",FILE$POTAS)
   FILE$DISES <- sprintf("%5s",FILE$DISES)
   FILE$CHEM <- sprintf("%5s",FILE$CHEM)
   FILE$TILL <- sprintf("%5s",FILE$TILL)
   FILE$CO2 <- sprintf("%5s",FILE$CO2)
   colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}

### tHIRD option
sheet_a <- sheet[,c(1,23:35)]
sheet_b <- unique(sheet_a)
#split data farme
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Sim3/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Sim3/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  FILE[is.na(FILE)] <- " "
  colnames(FILE)[1] <- "N"
  FILE$N <- sprintf("%2d",as.integer(FILE$N))
  FILE$METHODS <- sprintf("%-11s",FILE$METHODS)
  FILE$WTHER <- sprintf("%5s",FILE$WTHER)
  FILE$INCON <- sprintf("%5s",FILE$INCON)
  FILE$LIGHT <- sprintf("%5s",FILE$LIGHT)
  FILE$EVAPO <- sprintf("%5s",FILE$EVAPO)
  FILE$INFIL <- sprintf("%5s",FILE$INFIL)
  FILE$PHOTO <- sprintf("%5s",FILE$PHOTO)
  FILE$HYDRO <- sprintf("%5s",FILE$HYDRO)
  FILE$NSWIT <- sprintf("%5d",as.integer(FILE$NSWIT))
  FILE$MESOM <- sprintf("%5s",FILE$MESOM)
  FILE$MESEV <- sprintf("%5s",FILE$MESEV)
  FILE$MESOL <- sprintf("%5d",as.integer(FILE$MESOL))
  colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}

##fourth option
sheet_a <- sheet[,c(1,36:42)]
sheet_b <- unique(sheet_a)
#split data farme
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Sim4/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Sim4/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i],stringsAsFactors = F,colClasses = c("character"))
  FILE[is.na(FILE)] <- " "
  colnames(FILE)[1] <- "N"
   FILE$N <- sprintf("%2d",as.integer(FILE$N))
  FILE$MANAGEMENT <- sprintf("%-11s",FILE$MANAGEMENT)
  FILE$PLANT <- sprintf("%5s",FILE$PLANT)
  FILE$IRRIG <- sprintf("%5s",FILE$IRRIG)
  FILE$FERTI <- sprintf("%5s",FILE$FERTI)
  FILE$RESID <- sprintf("%5s",FILE$RESID)
  FILE$HARVS <- sprintf("%5s",FILE$HARVS)
  colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}

sheet_a <- sheet[,c(1,43:(ncol(sheet)-1))]
sheet_b <- unique(sheet_a)
#split data farme
dfs <- split(sheet_b[2:ncol(sheet_b)],sheet$Name_A)
# splitting all filex into seperate csv files
for (i in names(dfs)){
  write.csv(dfs[[i]],paste0(getwd(),"/Sim5/",i,".csv"),row.names = F)
}
# read all csv files and write in fixed widh text files and remove csv files 
FILES <- list.files(path = paste0(getwd(),"/Sim5/"),pattern=".csv$",full.names = T)
for (i in 1:length(FILES)) {
  FILE=read.csv(file=FILES[i])
  FILE[is.na(FILE)] <- " "
  colnames(FILE)[1] <- "N"
  FILE$N <- sprintf("%2d",as.integer(FILE$N))
  FILE$OUTPUTS <- sprintf("%-11s",FILE$OUTPUTS)
  FILE$FNAME <- sprintf("%5s",FILE$FNAME)
  FILE$OVVEW <- sprintf("%5s",FILE$OVVEW)
  FILE$SUMRY <- sprintf("%5s",FILE$SUMRY)
  FILE$FROPT <- sprintf("%5s",FILE$FROPT)
  FILE$GROUT <- sprintf("%5s",FILE$GROUT)
  FILE$CAOUT <- sprintf("%5s",FILE$CAOUT)
  FILE$WAOUT <- sprintf("%5s",FILE$WAOUT)
  FILE$NIOUT <- sprintf("%5s",FILE$NIOUT)
  FILE$DIOUT <- sprintf("%5s",FILE$DIOUT)
  FILE$VBOSE <- sprintf("%5s",FILE$VBOSE)
  FILE$CHOUT <- sprintf("%5s",FILE$CHOUT)
  FILE$OPOUT <- sprintf("%5s",FILE$OPOUT)
  FILE$FMOPT <- sprintf("%5s",FILE$FMOPT)
  colnames(FILE)[1] <- "@N"
  # #w1 <- do.call(pmax, as.data.frame(nchar(as.matrix(FILE[,4]))))
  write.table(FILE,file=paste0(sub(".csv","",FILES[i]),".txt"),row.names = F,col.names = T,quote = F)
}
### Pate the header and dataframes 
genmodeldats <- function(inputfold1,inputfold2,inputfold3,inputfold4,inputfold5,outdir){
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
    for(i in c(filex1,filex2,filex3,filex4,filex5)){
      file.append(modeldat,i)
    }
    message("Filex written written to ",modeldat)
  }
}
genmodeldats(paste0(getwd(),"/Sim1/"),paste0(getwd(),"/Sim2/"),paste0(getwd(),"/Sim3/"),paste0(getwd(),"/Sim4/"),paste0(getwd(),"/Sim5/")
            ,paste0(getwd(),"/Sim6"))

unlink("Sim1",recursive = T)
unlink("Sim2",recursive = T)
unlink("Sim3",recursive = T)
unlink("Sim4",recursive = T)
unlink("Sim5",recursive = T)
file.remove("hdr.txt")
# 
# ####
# 
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
# genmodeldats(inputfold1 = "C:/Users/ponraj/Desktop/filex/Sim6/","C:/Users/ponraj/Desktop/filex/Sim/")
# 
# unlink("Sim6",recursive = T)
