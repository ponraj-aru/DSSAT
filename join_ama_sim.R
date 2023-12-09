library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
##setwd and path Major FILEX path
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
dir.create(file.path(getwd(),"Ama_Sim1"),showWarnings = FALSE)
dir.create(file.path(getwd(),"Ama_Sim"),showWarnings = FALSE)
#dir.create(file.path(getwd(),"Ama_Sim_F"),showWarnings = FALSE)

hdr <- "*SIMULATION CONTROLS" 
write.fwf(as.data.frame(hdr),"hdr.txt",quoteInfo = F,rownames = F,
          colnames = F)
genmodeldats <- function(inputfold1,inputfold2,outdir){
  # Find common filenames in each folder
  filex1 <- tools::file_path_sans_ext(list.files(inputfold1,pattern = "^.*\\.txt$"))
  filex2 <- tools::file_path_sans_ext(list.files(inputfold2,pattern = "^.*\\.txt$"))
  # switchf <- tools::file_path_sans_ext(list.files(switchfold,pattern = "^.*\\.DAT$"))
  commonf <- Reduce(base::intersect,list(filex1))
  # Now append all these files and write to outdir
  for(f in commonf){
    # New file name
    modeldat <- file.path(outdir,paste0(f,".txt"))
    #path for spliited filex
    filex1 <- file.path(inputfold1,paste0(f,".txt"))
    filex2 <- file.path(inputfold2,paste0(f,".txt"))
    cat("",file=modeldat,append=FALSE)
    for(i in c(filex1,"\n",filex2)){
      file.append(modeldat,i)
    }
    message("Filex written written to ",modeldat)
  }
}
genmodeldats(paste0(getwd(),"/Sim6/"),paste0(getwd(),"/Ama6/"),paste0(getwd(),"/Ama_Sim1/"))

####end text
hdr <- ""
write.fwf(as.data.frame(hdr),"end.txt",quoteInfo = F,rownames = F,
          colnames = F)

genmodeldats <- function(inputfold1,header,outdir,header1){
  nf <- substr(tools::file_path_sans_ext(list.files(inputfold1,pattern = "^.*\\.txt$")),1,8)
  commonf <- Reduce(base::intersect,list(unique(nf)))
  for(f in commonf){
    # New file name
    modeldat <- file.path(outdir,paste0(f,".txt"))
    #path for spliited filex
    filex1 <-  mixedsort(sort(list.files(inputfold1,pattern = paste0(paste0(f),".*txt"),full.names = T)))
    # filex2 <- file.path(inputfold2,paste0(f,".txt"))
    # filex3 <- file.path(inputfold3,paste0(f,".txt"))
    # filex4 <- file.path(inputfold4,paste0(f,".txt"))
    # filex5 <- file.path(inputfold5,paste0(f,".txt"))

    cat("",file=modeldat,append=FALSE)
    for(i in c(header,filex1,header1)){
      file.append(modeldat,i)
    }
    message("Filex written written to ",modeldat)
  }
}

genmodeldats(inputfold1 = "C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/Ama_Sim1/",header = "hdr.txt","C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/Ama_Sim/",header1 = "end.txt")

#unlink("Sim6",recursive = T)
#unlink("Ama6",recursive = T)
unlink("Ama_Sim1",recursive = T)
file.remove("end.txt")
file.remove("hdr.txt")