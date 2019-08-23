# Set-up directory and download file 
if(!file.exists("./Project2")){dir.create("./Project2")}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./Project2/FNEI_data.zip", method = "curl")
unzip("./Project2/FNEI_data.zip", exdir = "./FNEI")
list.files("./FNEI")

## Read the files  
NEI <- readRDS("./FNEI/summarySCC_PM25.rds")
SCC <- readRDS("./FNEI/Source_Classification_Code.rds")

## Have total emissions from PM2.5 decreased in the US from
## 1999 to 2008? Use BASE plotting system

## Organize data set 
library(tidyverse)
data1 <- NEI %>% group_by(year) %>% 
  summarize(sum(Emissions)) %>% data.frame()

## Plot the data 
png("plot1.png", width = 480, height = 480)
with(data1, plot(year, sum.Emissions., type = "b", 
                 col = "blue", main = "Total US Emissions",
                 xlab = "Year", ylab = "PM2.5 in Tons"))
dev.off()

