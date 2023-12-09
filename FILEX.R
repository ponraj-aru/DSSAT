library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
##setwd and path Major FILEX path
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
dir.create(file.path(getwd(),"FILEX"),showWarnings = FALSE)
hdr <- file("hdr.txt","w")
writeLines("*EXP.DETAILS: WEST.AFRICA_SORGHUM_GEO_SPATIAL SIMULATION 2001-2016",hdr,sep = "\n\n")
writeLines("*GENERAL",hdr,sep = "\n")
writeLines("@PEOPLE",hdr,sep = "\n")
writeLines("Ponraj Arumugam, PIK",hdr,sep = "\n")
writeLines("@ADDRESS",hdr,sep = "\n")
writeLines("PIK, Telegraphenberg, Potsdam, Germany",hdr,sep = "\n")
writeLines("@SITE",hdr,sep = "\n")
writeLines("India",hdr,sep = "\n")
close(hdr)

genmodeldats <- function(inputfold1,inputfold2,inputfold3,inputfold4,inputfold5,inputfold6,inputfold7,inputfold8,inputfold9,inputfold10,inputfold11,
                         header,outdir){
  # Find common filenames in each folder
  filex1 <- tools::file_path_sans_ext(list.files(inputfold1,pattern = "^.*\\.txt$"))
  filex2 <- tools::file_path_sans_ext(list.files(inputfold2,pattern = "^.*\\.txt$"))
  filex3 <- tools::file_path_sans_ext(list.files(inputfold3,pattern = "^.*\\.txt$"))
  filex4 <- tools::file_path_sans_ext(list.files(inputfold4,pattern = "^.*\\.txt$"))
  filex5 <- tools::file_path_sans_ext(list.files(inputfold5,pattern = "^.*\\.txt$"))
  filex6 <- tools::file_path_sans_ext(list.files(inputfold6,pattern = "^.*\\.txt$"))
  filex7 <- tools::file_path_sans_ext(list.files(inputfold7,pattern = "^.*\\.txt$"))
  filex8 <- tools::file_path_sans_ext(list.files(inputfold8,pattern = "^.*\\.txt$"))
  filex9 <- tools::file_path_sans_ext(list.files(inputfold9,pattern = "^.*\\.txt$"))
  filex10 <- tools::file_path_sans_ext(list.files(inputfold10,pattern = "^.*\\.txt$"))
  filex11 <- tools::file_path_sans_ext(list.files(inputfold11,pattern = "^.*\\.txt$"))
  # switchf <- tools::file_path_sans_ext(list.files(switchfold,pattern = "^.*\\.DAT$"))
  commonf <- Reduce(base::intersect,list(filex1))
  # Now append all these files and write to outdir
  for(f in commonf){
    # New file name
    modeldat <- file.path(outdir,paste0(f,".SNX"))
    #path for spliited filex
    filex1 <- file.path(inputfold1,paste0(f,".txt"))
    filex2 <- file.path(inputfold2,paste0(f,".txt"))
    filex3 <- file.path(inputfold3,paste0(f,".txt"))
    filex4 <- file.path(inputfold4,paste0(f,".txt"))
    filex5 <- file.path(inputfold5,paste0(f,".txt"))
    filex6 <- file.path(inputfold6,paste0(f,".txt"))
    filex7 <- file.path(inputfold7,paste0(f,".txt"))
    filex8 <- file.path(inputfold8,paste0(f,".txt"))
    filex9 <- file.path(inputfold9,paste0(f,".txt"))
    filex10 <- file.path(inputfold10,paste0(f,".txt"))
    filex11 <- file.path(inputfold11,paste0(f,".txt"))
    
    cat("",file=modeldat,append=FALSE)
    for(i in c(header,filex1,filex2,filex3,filex4,filex5,filex6,filex7,filex8,filex9,filex10,filex11)){
      file.append(modeldat,i)
    }
    message("Filex written written to ",modeldat)
  }
}
genmodeldats(inputfold1 = paste0(getwd(),"/Treatment/"),inputfold2 = paste0(getwd(),"/Cultivar/"),inputfold3 = 
              paste0(getwd(),"/Fields/"),inputfold4 = paste0(getwd(),"/SA/"),inputfold5 = paste0(getwd(),"/IC/"),inputfold6 = 
                paste0(getwd(),"/Planting/"),inputfold7 = paste0(getwd(),"/Harvesting/"),inputfold8 = paste0(getwd(),"/IR/"),inputfold9 = paste0(getwd(),"/FR/"),
             inputfold10 = paste0(getwd(),"/RR/"),header = "hdr.txt",inputfold11 = paste0(getwd(),"/Ama_Sim/"),outdir = paste0(getwd(),"/RICE/")) 
                
# unlink("Ama1",recursive = T)
# unlink("Ama2",recursive = T)
# unlink("Ama3",recursive = T)
# unlink("Ama4",recursive = T)
# unlink("Ama5",recursive = T)
file.remove("hdr.txt")
