# Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_181/")
# options(java.parameters = "-Xmx4g")
library(readxl)
library(gdata)
library(tidyverse)
library(miceadds)
library(data.table)
library(dplyr)
##setwd and path Major FILEX path

dir.create(file.path(getwd(),"FOW"),showWarnings = FALSE)
setwd("C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/filex/")
FILEX <- "C:/Users/arumu002/OneDrive - Wageningen University & Research/ponraj_PIK_data/DSSAT_KARNATAK/FILEX_DSSAT.xlsx"
sheet1 <- read_excel(FILEX,sheet = "FOW")
sheet_c <- filter(sheet1, Year <= 2014)
sheet_f <- filter(sheet1, Year >= 2015)

fn <- "FOW//SOURCE_current.MOW"
file.remove(fn)
hdr1 <- "!This file is for parameters controlling simulated mowing events for alfalfa"
write.table(hdr1,fn,append=TRUE, quote=F,row.names = F,col.names = F)
hdr2 <- "!for CROPGRO-Forage model."
write(hdr2,fn,append = T)
hdr3 <- "!Mow height is not used any where, except to affect canopy height as m or cm."
write(hdr3,fn,append = T)
hdr4 <- "@TRNO   DATE   MOW RSPLF   MVS  RSHT"
write(hdr4,fn,append = T)

sheet_c$date <- paste0(substr(sheet_c$Year,3,4),sheet_c$DOY1)
sheet1 <- data.frame(sheet_c$TRNO,sheet_c$date,sheet_c$MOW,sheet_c$RSPLF,sheet_c$MVS,sheet$RSHT)
names(sheet1) <- c("TRNO","date","MOW","RSPLF","MVS","RSHT")

sheet1$TRNO <- sprintf("%6.0f",sheet1$TRNO)
sheet1$date <- sprintf("%5s",sheet1$date)
sheet1$MOW <- sprintf("%5.0f",sheet1$MOW)
sheet1$RSPLF <- sprintf("%5.0f",sheet1$RSPLF)
sheet1$MVS <- sprintf("%5.0f",sheet1$MVS)
sheet1$RSHT <- sprintf("%5.1f",sheet1$RSHT)

write.table(sheet1, fn, append=TRUE, quote=F,row.names = F,col.names = F)

###################### FUTURE FOW file #############################

fn <- "FOW//SOURCE_future.MOW"
file.remove(fn)
hdr1 <- "!This file is for parameters controlling simulated mowing events for alfalfa"
write.table(hdr1,fn,append=TRUE, quote=F,row.names = F,col.names = F)
hdr2 <- "!for CROPGRO-Forage model."
write(hdr2,fn,append = T)
hdr3 <- "!Mow height is not used any where, except to affect canopy height as m or cm."
write(hdr3,fn,append = T)
hdr4 <- "@TRNO   DATE   MOW RSPLF   MVS  RSHT"
write(hdr4,fn,append = T)

sheet_f$date <- paste0(substr(sheet_f$Year,3,4),sheet_f$DOY1)
sheet1 <- data.frame(sheet_f$TRNO,sheet_f$date,sheet_f$MOW,sheet_f$RSPLF,sheet_f$MVS,sheet_f$RSHT)
names(sheet1) <- c("TRNO","date","MOW","RSPLF","MVS","RSHT")

sheet1$TRNO <- sprintf("%6.0f",sheet1$TRNO)
sheet1$date <- sprintf("%5s",sheet1$date)
sheet1$MOW <- sprintf("%5.0f",sheet1$MOW)
sheet1$RSPLF <- sprintf("%5.0f",sheet1$RSPLF)
sheet1$MVS <- sprintf("%5.0f",sheet1$MVS)
sheet1$RSHT <- sprintf("%5.1f",sheet1$RSHT)

write.table(sheet1, fn, append=TRUE, quote=F,row.names = F,col.names = F)

