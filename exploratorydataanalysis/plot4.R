rm(list=ls())
library(wesanderson)
library(dplyr)
library(ggplot2)

#reading data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#merging NEI and SCC data sets
mergedtables <- merge(NEI, SCC, by="SCC")

#filtering coal-related emissions and summarizing by year to get totals
coal <- mergedtables %>% filter(grepl("coal", SCC.Level.Four, ignore.case=TRUE)) %>% group_by(year)  %>% summarize(Emissions=sum(Emissions)/1000) 

png(filename='plot4.png')

#plotting
par(mar=c(5, 6, 6, 2))
ggplot(data=coal, aes(x=as.character(year), y=Emissions, fill=as.character(year))) +
    geom_bar(stat="identity", position=position_dodge(), show.legend = FALSE) + 
    scale_fill_manual(values=wes_palette("FantasticFox1")) + 
    xlab("Year") +
    ylab("Total emissions\n(in thousands of tons)") +
    ggtitle("Total coal-related PM2.5 Emissions in the United States\nfrom 1999 to 2008") +
    theme(plot.title = element_text(hjust = 0.5))

dev.off()