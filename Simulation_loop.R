d <-  read.csv("/lustre/scratch/WUR/ESG/arumu002/dssat/Location_filex.csv")
fn <- list.files(path = "/lustre/scratch/WUR/ESG/arumu002/dssat/Seasonal",pattern = "SORG*")
fns <- substr(fn,1,8)
lf <- data.frame()
for(i in fns){
  df <- dplyr::filter(d,GRID_NAME==i)
  lf <- rbind(lf,df)
}
#chnage to "1586.WTH" if scenario is future
names <- paste0(lf$Location,"1586.WTH")
# this is fixes path, no need to modify until unless you move this folder 
# to some other location
dir <- "/lustre/scratch/WUR/ESG/arumu002/DSSAT_wth_files/"
scenario <- "ssp126"

fdir <- paste0(dir,scenario)
dirs <- list.dirs(fdir, recursive = F)
for(j in dirs[1]){
  f <- paste0(j,"/",names)
  print(paste0("Copying from ", j))
  file.copy(f,"/lustre/scratch/WUR/ESG/arumu002/dssat/Weather",overwrite = TRUE, recursive = FALSE,copy.mode = TRUE)
  print(paste0("Copied from ", j))
  #setwd("/lustre/scratch/WUR/ESG/arumu002/dssat/Seasonal")
  #system("../run_dssat B DSSBatch.v47")
}


f = list.dirs(path = "/p/projects/agrica/d/cur_gcms/", full.names = TRUE, recursive = F)
f1 = list.dirs(path = "/p/projects/agrica/d/cur_gcms/", full.names = F, recursive = F)
f2 = paste0(f,"/",f1)
for (i in f2){
  lf = list.files(paste0(i,"/","wth_final"),pattern="*.WTH",full.names = T)
  print(paste0(i,"/","wth_final"))
  file.copy(from=lf, to="/p/projects/epicc/data/dssat/Weather/",overwrite = TRUE, recursive = FALSE,copy.mode = TRUE)
  setwd("/p/projects/epicc/data/dssat/Seasonal")
  system("../dscsm047 B DSSBatch.v47")
  names = substr(i,32,nchar(i))
  names1 = substr(names,1,nchar(names)/2-0.5)
  print(paste0("model simulaion is completed for",names))
  file.copy("/p/projects/epicc/data/dssat/Seasonal/Summary.OUT",
            to=paste0("/p/projects/agrica/d/Summary_",names1,".OUT"),
            overwrite = TRUE, recursive = FALSE,copy.mode = TRUE)
}
