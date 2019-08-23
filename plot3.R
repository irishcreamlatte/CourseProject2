# Set-up directory and download file 
if(!file.exists("./Project2")){dir.create("./Project2")}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./Project2/FNEI_data.zip", method = "curl")
unzip("./Project2/FNEI_data.zip", exdir = "./FNEI")
list.files("./FNEI")

## Read the files  
NEI <- readRDS("./FNEI/summarySCC_PM25.rds")
SCC <- readRDS("./FNEI/Source_Classification_Code.rds")

## Of the 4 types of sources, which have seen decreases in 
## emissions for Baltimore? Which have seen increases in  
## emissions? Use GGPLOT2 

## Organize the data set

library(tidyverse)
data3 <- NEI %>% filter(fips == "24510") %>% 
  group_by(year, type) %>% summarize(sum(Emissions)) %>% 
  data.frame()

## Plot the data 
png("plot3.png", width = 480, height = 480)
data3 %>% ggplot(aes(year, sum.Emissions., col = type)) + 
  geom_point() + geom_line() + labs(title = "Total Emissions in Baltimore by Type", x = "Year", y = "PM2.5 in Tons")
dev.off()
