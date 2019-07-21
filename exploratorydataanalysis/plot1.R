rm(list=ls())
library(wesanderson)

#reading data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#summing all emissions and changing scale for better reading
total_emmissions <- tapply(NEI$Emissions/1000000, NEI$year, FUN=sum)

png(filename='plot1.png')

#plotting
par(mar=c(5, 6, 6, 2))
barplot(total_emmissions, col=wes_palette("IsleofDogs2"), ylab="Total emissions\n(in millions of tons)", xlab="Year")
title(main="Total PM2.5 Emissions in the United States\nfrom 1999 to 2008")

dev.off()