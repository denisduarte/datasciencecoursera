rm(list=ls())
library(wesanderson)

#reading data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subseting Baltimore data
baltimore <- subset(NEI, NEI$fips=="24510")

#summing all Baltimore emissions 
total_baltimore_emissions <- tapply(baltimore$Emissions, baltimore$year, FUN=sum)

png(filename='plot2.png')

#plotting
par(mar=c(5, 6, 6, 2))
barplot(total_baltimore_emissions, col=wes_palette("Moonrise2"), ylab="Total emissions\n(in tons)", xlab="Year")
title(main="Total PM2.5 Emissions in Baltimore City\nfrom 1999 to 2008")

dev.off()