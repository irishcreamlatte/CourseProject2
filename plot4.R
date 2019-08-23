# Set-up directory and download file 
if(!file.exists("./Project2")){dir.create("./Project2")}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./Project2/FNEI_data.zip", method = "curl")
unzip("./Project2/FNEI_data.zip", exdir = "./FNEI")
list.files("./FNEI")

## Read the files  
NEI <- readRDS("./FNEI/summarySCC_PM25.rds")
SCC <- readRDS("./FNEI/Source_Classification_Code.rds")

## Across the US, have emissions from coal combustion-related 
## sources changed? 

## Organize the data set 

library(tidyverse)
index <- grepl("Coal", SCC$EI.Sector)
subsetSCC <- SCC[index, ] %>% select(SCC) 
scc <- as.vector(subsetSCC$SCC)
data4 <- NEI %>% filter(SCC %in% scc) %>% group_by(year) %>%
  summarize(sum(Emissions)) %>% data.frame()

## Plot the data
png("plot4.png", width = 480, height = 480)
data4 %>% ggplot(aes(year, sum.Emissions.)) +
  geom_point() + geom_line() + labs(title = "US Emissions from Coal", x = "Year", y = "PM2.5 in Tons")
dev.off()

