library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
library(dplyr)
##setwd and path Major FILEX path
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
FILEX <- "C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/DSSAT_KARNATAK/FILEX_DSSAT.xlsx"
Country <- c("Burkina Faso","Niger","Mali")
dir.create(file.path(getwd(),"ROI_files"),showWarnings = FALSE)

sheet <- read_excel(FILEX,sheet = 1)
sheet1 <- filter(sheet,District==Country)

fn <- paste0(getwd(),"/RICE_FUTURE/",unique(sheet1$GRID_NAME),".SNX")
for(i in fn){
  file.copy(i, paste0(getwd(),"/ROI_files/"),overwrite = T,copy.mode = TRUE)
}

