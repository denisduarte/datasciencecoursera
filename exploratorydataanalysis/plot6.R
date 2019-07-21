rm(list=ls())
library(wesanderson)
library(dplyr)
library(ggplot2)

#reading data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#defining cities
cities <- data.frame(fips=c("24510", "06037"), City=c("Baltimore", "Los Angeles"))

#subseting Baltimore and LA data
baltimore_losangeles <- subset(NEI, NEI$fips=="24510" | NEI$fips=="06037")

#merging subsets with SCC
mergedtables <- baltimore_losangeles %>% merge(SCC, by="SCC") %>% merge(cities, by="fips") 

#filtering vehicle-related emissions and summarizing by year to get totals
vehicles <- mergedtables %>% filter(grepl("vehicle", SCC.Level.Two, ignore.case=TRUE)) %>% group_by(City, year)  %>% summarize(Emissions=sum(Emissions)/1000) 

png(filename='plot6.png')

#plotting
par(mar=c(5, 6, 6, 2))
ggplot(vehicles, aes(as.character(year), Emissions, fill=City)) +
    geom_bar(stat="identity", position="dodge") + 
    scale_fill_manual(values=wes_palette("GrandBudapest1")) + 
    xlab("Year") +
    ylab("Total emissions\n(in thousands of tons)") +
    ggtitle("Total motor vehicle PM2.5 Emissions\nin Baltimore City and Los Angeles from 1999 to 2008") +
    theme(plot.title = element_text(hjust = 0.5))

dev.off()