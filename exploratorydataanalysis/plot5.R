rm(list=ls())
library(wesanderson)
library(dplyr)
library(ggplot2)

#reading data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subseting Baltimore data
baltimore <- subset(NEI, NEI$fips=="24510")

#merging Baltimore data with SCC
mergedtables <- merge(baltimore, SCC, by="SCC")

#filtering vehicle-related emissions and summarizing by year to get totals
vehicles <- mergedtables %>% filter(grepl("vehicle", SCC.Level.Two, ignore.case=TRUE)) %>% group_by(year)  %>% summarize(Emissions=sum(Emissions)/1000) 

png(filename='plot5.png')

#plotting
par(mar=c(5, 6, 6, 2))
ggplot(data=vehicles, aes(x=as.character(year), y=Emissions, fill=as.character(year))) +
    geom_bar(stat="identity", position=position_dodge(), show.legend = FALSE) + 
    scale_fill_manual(values=wes_palette("GrandBudapest2")) + 
    xlab("Year") +
    ylab("Total emissions\n(in thousands of tons)") +
    ggtitle("Total motor vehicle PM2.5 Emissions in Baltimore City\nfrom 1999 to 2008") +
    theme(plot.title = element_text(hjust = 0.5))

dev.off()

