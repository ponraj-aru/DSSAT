library(DSSAT)
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
batch_file_path <- "All.v47"
batch_file_path1 <- "Regions.v47"

f1 <- list.files("RICE/",pattern = ".SNX$")
f2 <- list.files("ROI_files/",pattern = ".SNX$")
path <- "/lustre/scratch/WUR/ESG/arumu002/dssat/Seasonal"
file <- paste0(path,"/",f2)

batch_tbl <- data.frame()
for (i in file){
  df <-  data.frame(FILEX=i,TRTNO=1:99,RP=1,SQ=0,OP=0,CO=0)
  batch_tbl <- rbind(df,batch_tbl)
}

write_dssbatch(batch_tbl, file_name = batch_file_path1)

