# Set-up directory and download file 
if(!file.exists("./Project2")){dir.create("./Project2")}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./Project2/FNEI_data.zip", method = "curl")
unzip("./Project2/FNEI_data.zip", exdir = "./FNEI")
list.files("./FNEI")

## Read the files  
NEI <- readRDS("./FNEI/summarySCC_PM25.rds")
SCC <- readRDS("./FNEI/Source_Classification_Code.rds")

## How have emissions from motor vehicle sources changed
## for Baltimore? 

## Organize the data set 
library(tidyverse)
index2 <- grepl("Mobile - On-Road", SCC$EI.Sector)
subsetSCC2 <- SCC[index2, ] %>% select(SCC)
SCCsub2 <- as.vector(subsetSCC2$SCC)
data5 <- NEI %>% filter(SCC %in% SCCsub2 & fips == "24510") %>%
  group_by(year) %>% summarize(sum(Emissions)) %>% data.frame()

# Plot the Data
png("plot5.png", width = 480, height = 480)
data5 %>% ggplot(aes(year, sum.Emissions.)) +
  geom_point() + geom_line() + 
  labs(title = "Motor Vehicle Emissions in Baltimore", x = "Year", y = "PM2.5 in Tons")
dev.off()
