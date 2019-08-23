# Set-up directory and download file 
if(!file.exists("./Project2")){dir.create("./Project2")}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./Project2/FNEI_data.zip", method = "curl")
unzip("./Project2/FNEI_data.zip", exdir = "./FNEI")
list.files("./FNEI")

## Read the files  
NEI <- readRDS("./FNEI/summarySCC_PM25.rds")
SCC <- readRDS("./FNEI/Source_Classification_Code.rds")

## Compare emissions from motor vehicle sources in Baltimore 
## with emissions from motor vehicle sources in Los Angeles County. 
## Which city has seen greater changes over time? 

## Organize the data 
library(tidyverse)
index2 <- grepl("Mobile - On-Road", SCC$EI.Sector)
subsetSCC2 <- SCC[index2, ] %>% select(SCC)
SCCsub2 <- as.vector(subsetSCC2$SCC)

data6 <- NEI %>% filter(SCC %in% SCCsub2 & fips == "24510" | fips == "06037") %>% 
  group_by(year, fips) %>% summarize(sum(Emissions)) %>% data.frame() 

data6$fips <- gsub("24510", "Baltimore", data6$fips)  
data6$fips <- gsub("06037", "LA County", data6$fips)

## Plot the data 
png("plot6.png", width = 480, height = 480)
data6 %>% rename(County = fips) %>% 
  ggplot(aes(year, sum.Emissions., col = County)) +
  geom_point() + geom_line() + 
  labs(title = "Motor Vehicle Emissions in Baltimore and LA County", x = "Year", y = "PM2.5 in Tons") 
dev.off()