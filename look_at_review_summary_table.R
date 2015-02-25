## look at review summary table

## load packages
require(maptools)
library(rgdal)
library(devtools)
install_git("git://github.com/gsk3/taRifx.geo.git")
library(taRifx.geo)


## directories
chr.dir <- "//deqhq1/tmdl/TMDL_WR/MidCoast/Models/Bacteria/LDC"
chr.dir.data <- paste0(chr.dir,"/Results")
chr.stat.dir.shp <- "//deqhq1/tmdl/TMDL_WR/MidCoast/GIS/BacteriaTMDL/Mult_Basins/StreamStats/FreshwaterBacteriaStations/shapefiles"

## raw data table
df.raw <- read.csv(file=paste0(chr.dir.data,"/","LDC Review Packet Summary (draft 00 201501081453).csv"), stringsAsFactors=FALSE)

## stations with reductions >0%
df.reds <- df.raw[grep("(0%)|(NA)",df.raw$X..Reduction),]

## watersheds with reductions
unique(df.reds$Watershed)
unique(df.raw$Watershed)
paste0(sprintf(fmt="%.1f",100*length(unique(df.reds$Watershed))/length(unique(df.raw$Watershed))),"%")
paste0(sprintf(fmt="%d out of ", length(unique(df.reds$Watershed))),sprintf(fmt="%d basins in the Mid-Coast with reductions",length(unique(df.raw$Watershed))))


## stations with reductions
paste0(sprintf(fmt="%.1f",100*length(unique(df.reds$Station))/length(unique(df.raw$Station))),"%")
paste(unique(df.reds$Station[order(df.reds$Station)]), collapse=" ,")
paste0(sprintf(fmt="%d out of ", length(unique(df.reds$Station))),sprintf(fmt="%d stations with reductions",length(unique(df.raw$Station))))
## create single shapefile of waterseds with reductions
chr.sta <- paste0(chr.stat.dir.shp,"/st",unique(df.reds$Station[order(df.reds$Station)]),"WatershedOR")
chr.sta.alt <- paste0("st",unique(df.reds$Station[order(df.reds$Station)]),"WatershedOR")
rm(a)
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.alt[1],verbose=FALSE)
for(ii in 2:length(chr.sta.alt)) {
  print(paste0("ii is ",ii," and layer is ",chr.sta.alt[ii]))
  b<-readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.alt[ii],verbose=FALSE)
  a <- rbind(a,b, fix.duplicated.IDs=TRUE)
  row.names(a) <- chr.sta.alt[1:ii]
  rm(b)
}
writeOGR(a,dsn=chr.stat.dir.shp,layer="wtsd_red",driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a)

## stations with reduction and adequate data set
length(unique(df.reds$Station))
df.reds$Commnents
df.reds[grep("([Ss]trong)|( [Aa]dequate)|([Oo]k)",df.reds$Commnents),"Commnents"]
df.reds[-grep("inadequate",df.reds$Commnents), "Commnents"]
df.reds[-grep("([Nn]ot [Aa]dequate)",df.reds$Commnents), "Commnents"]
df.reds[-grep("[Nn]ot",df.reds$Commnents), "Commnents"]
## create single shapefile of waterseds with reductions
##chr.sta.ad <- paste0(chr.stat.dir.shp,"/st",unique(df.reds[-grep("(inadequate)|([Nn]ot)|(little)",df.reds$Commnents), "Station"]),"WatershedOR")
chr.sta.ad <- paste0("st",unique(df.reds[-grep("(inadequate)|([Nn]ot)|(little)",df.reds$Commnents), "Station"]),"WatershedOR")
paste(length(chr.sta.ad)," stations with reductions had adequate data")
rm(a)
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.ad[1],verbose=FALSE)
for(ii in 2:length(chr.sta.ad)) {
  print(paste0("ii is ",ii," and layer is ",chr.sta.ad[ii]))
  b<-readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.ad[ii],verbose=FALSE)
  a <- rbind(a,b, fix.duplicated.IDs=TRUE)
  row.names(a) <- chr.sta.alt[1:ii]
  rm(b)
}
writeOGR(a,dsn=chr.stat.dir.shp,layer="wtsd_red_adq",driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a)

df.adq <- df.reds[-grep("(inadequate)|([Nn]ot)|(little)",df.reds$Commnents), ]

## stations with reduction and adequate data set and On-Site potential sources
df.adq[grep("([Ss]eptic)|( [Oo]n)|([Ss]ite)|([Dd]irect)",df.adq$Sources),"Sources"]
df.adq[grep("direct",df.adq$Sources),"Sources"]

## create single shapefile of waterseds with reductions adequate data and on-site as source
##chr.sta.ad <- paste0(chr.stat.dir.shp,"/st",unique(df.reds[-grep("(inadequate)|([Nn]ot)|(little)",df.reds$Commnents), "Station"]),"WatershedOR")
chr.sta.os <- paste0("st",unique(df.adq[grep("([Ss]eptic)|( [Oo]n)|([Ss]ite)|([Dd]irect)",df.adq$Sources), "Station"]),"WatershedOR")
paste(length(chr.sta.os)," stations with reductions had adequate data")
rm(a)
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.os[1],verbose=FALSE)
for(ii in 2:length(chr.sta.os)) {
  print(paste0("ii is ",ii," and layer is ",chr.sta.os[ii]))
  b<-readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.os[ii],verbose=FALSE)
  a <- rbind(a,b, fix.duplicated.IDs=TRUE)
  row.names(a) <- chr.sta.alt[1:ii]
  rm(b)
}
writeOGR(a,dsn=chr.stat.dir.shp,layer="wtsd_red_adq_os",driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a)


## stations with reduction and adequate data set and Ag potential sources
df.adq[grep("([Aa]g)|([Ll]iv)|([Cc]attle)|([Dd]omestic)",df.adq$Sources),"Sources"]

## create single shapefile of waterseds with reductions adequate data and ag as source
##chr.sta.ad <- paste0(chr.stat.dir.shp,"/st",unique(df.reds[-grep("(inadequate)|([Nn]ot)|(little)",df.reds$Commnents), "Station"]),"WatershedOR")
chr.sta.ag <- paste0("st",unique(df.adq[grep("([Aa]g)|([Ll]iv)|[Cc]attle",df.adq$Sources),"Station"]),"WatershedOR")
paste(length(chr.sta.ag)," stations with reductions had adequate data")
rm(a)
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.ag[1],verbose=FALSE)
for(ii in 2:length(chr.sta.ag)) {
  print(paste0("ii is ",ii," and layer is ",chr.sta.ag[ii]))
  b<-readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.ag[ii],verbose=FALSE)
  a <- rbind(a,b, fix.duplicated.IDs=TRUE)
  row.names(a) <- chr.sta.alt[1:ii]
  rm(b)
}
writeOGR(a,dsn=chr.stat.dir.shp,layer="wtsd_red_adq_ag",driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a)

## stations with reduction and adequate data set and Stormwater Runoff potential sources
df.adq[grep("([Ss]torm)",df.adq$Sources),"Sources"]

## create single shapefile of waterseds with reductions adequate data and stormwater runoff as source
chr.sta.st <- paste0("st",unique(df.adq[grep("([Ss]torm)",df.adq$Sources),"Station"]),"WatershedOR")
paste(length(chr.sta.st)," stations with reductions had adequate data")
rm(a)
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.st[1],verbose=FALSE)
for(ii in 2:length(chr.sta.st)) {
  print(paste0("ii is ",ii," and layer is ",chr.sta.st[ii]))
  b<-readOGR(dsn=chr.stat.dir.shp,layer=chr.sta.st[ii],verbose=FALSE)
  a <- rbind(a,b, fix.duplicated.IDs=TRUE)
  row.names(a) <- chr.sta.alt[1:ii]
  rm(b)
}
writeOGR(a,dsn=chr.stat.dir.shp,layer="wtsd_red_adq_st",driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a)


## Look at Salmon River
df.raw[grep("Salmon",df.raw$Watershed),"Watershed"]
chr.st <- df.raw[grep("Salmon",df.raw$Watershed),]
chr.st[,c("Station","X..Reduction")]

## create single shapefile of waterseds in Salmon River
chr.a <- paste0("st",unique(df.raw$Station[df.raw$Watershed == "Salmon River"]),"WatershedOR")
paste(length(chr.a)," stations Salmon River")
rm(a)
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[1],verbose=FALSE)
for(ii in 2:length(chr.a)) {
  print(paste0("ii is ",ii," and layer is ",chr.a[ii]))
  b<-readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
  a <- rbind(a,b, fix.duplicated.IDs=TRUE)
  row.names(a) <- chr.sta.alt[1:ii]
  rm(b)
}
writeOGR(a,dsn=chr.stat.dir.shp,layer="wtsd_salmon_river",driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a)
rm(ii)
## 1 of 12 stations
ii<-1
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 2 of 12 stations
ii<-2
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 3 of 12 stations
ii<-3
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 4 of 12 stations
ii<-4
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 5 of 12 stations
ii<-5
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 6 of 12 stations
ii<-6
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 7 of 12 stations
ii<-7
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 8 of 12 stations
ii<-8
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 9 of 12 stations
ii<-9
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 10 of 12 stations
ii<-10
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 11 of 12 stations
ii<-11
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 12 of 12 stations
ii<-12
paste(chr.a[ii]," station in Salmon River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_salmon_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## create single shapefile of waterseds in Yachats River
chr.a <- paste0("st",unique(df.raw$Station[df.raw$Watershed == "Yachats River"]),"WatershedOR")
paste(length(chr.a)," stations Yachats River")
rm(a)
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[1],verbose=FALSE)
for(ii in 2:length(chr.a)) {
  print(paste0("ii is ",ii," and layer is ",chr.a[ii]))
  b<-readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
  a <- rbind(a,b, fix.duplicated.IDs=TRUE)
  row.names(a) <- chr.sta.alt[1:ii]
  rm(b)
}
writeOGR(a,dsn=chr.stat.dir.shp,layer="wtsd_Yachats_river",driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a)


## Look at Yachats River
df.raw[grep("Yachats",df.raw$Watershed),"Watershed"]
chr.st <- df.raw[grep("Yachats",df.raw$Watershed),]
paste0(length(chr.st$Station)," Stations in Yachats River")
chr.st[,c("Station","X..Reduction")]

## create single shapefile of waterseds in Salmon River
chr.a <- paste0("st",unique(df.raw$Station[df.raw$Watershed == "Yachats River"]),"WatershedOR")
paste(length(chr.a)," stations Yachets River")
rm(a)
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[1],verbose=FALSE)
for(ii in 2:length(chr.a)) {
  print(paste0("ii is ",ii," and layer is ",chr.a[ii]))
  b<-readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
  a <- rbind(a,b, fix.duplicated.IDs=TRUE)
  row.names(a) <- chr.sta.alt[1:ii]
  rm(b)
}
writeOGR(a,dsn=chr.stat.dir.shp,layer="wtsd_yachats_river",driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a)
rm(ii)
## 1 of 11 stations
ii<-1
paste(chr.a[ii]," station in Yachats River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_yachats_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 2 of 11 stations
ii<-2
paste(chr.a[ii]," station in Yachats River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_yachats_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)

## 1 of 11 stations
ii<-1
paste(chr.a[ii]," station in Yachats River")
chr.st[ii,c("Station","X..Reduction")]
chr.st[ii,c("Station","Sources")]
a <- readOGR(dsn=chr.stat.dir.shp,layer=chr.a[ii],verbose=FALSE)
writeOGR(a,dsn=chr.stat.dir.shp,layer=paste0("wtsd_yachats_river_",chr.st[ii,"Station"]),driver="ESRI Shapefile",overwrite_layer=TRUE)
rm(a,ii)
