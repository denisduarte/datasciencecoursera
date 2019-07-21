rm(list=ls())
library(wesanderson)
library(dplyr)
library(ggplot2)

#reading data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subseting Baltimore data
baltimore <- subset(NEI, NEI$fips=="24510")

#grouping Baltimore emissions by type and year and summarizing to get totals
total_baltimore_emissions_bytype <- baltimore %>% group_by(type, year) %>% summarize(Emissions=sum(Emissions))

png(filename='plot3.png')

#plotting
par(mar=c(5, 6, 6, 2))
ggplot(data=total_baltimore_emissions_bytype, aes(x=as.character(year), y=Emissions, fill=type)) +
    geom_bar(stat="identity", position=position_dodge()) + 
    scale_fill_manual(values=wes_palette("Moonrise3")) + 
    xlab("Year") +
    ylab("Total emissions\n(in tons)") +
    ggtitle("Total PM2.5 Emissions in Baltimore City\nfrom 1999 to 2008 by type") +
    theme(plot.title = element_text(hjust = 0.5))

dev.off()