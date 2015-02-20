#DS04 Exploratory Data Analysis Project 2, plot1.R

#Q1 Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#A: They appear to have decreased from ~7.5Mt to ~ 3 Mt.

# utility function #Thanks StackOverflow!
InstallIfNeeded <- function(pkg)  {
 if (!require(pkg, character.only = TRUE)) {
     install.packages(pkg)
     if (!require(pkg, character.only = TRUE)) stop(paste("load failure:", pkg))
 }
}

# install/load libraries as necessary
InstallIfNeeded("dplyr")
InstallIfNeeded("ggplot2")

#-----Read data into current folder
fnPM25Emissions <- "summarySCC_PM25.rds"
fnSCCTable <- "Source_Classification_Code.rds"

if ( !file.exists(fnPM25Emissions ) | !file.exists(fnSCCTable) ) {
    message("Data file(s) missing, downloading....")
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","exdata_data_NEI_data.zip")
    message("Unzipping data files...")
    unzip("exdata_data_NEI_data.zip")
}

#----- Only re-read variable if necessary   #NEI takes about 20 seconds to read
if (!exists("NEI")) {
    message("NEI missing, now reading...")
    NEI <- readRDS("summarySCC_PM25.rds")
} 
if (!exists("SCC")) {
    message("SCC missing, now reading...")
    SCC <- readRDS("Source_Classification_Code.rds")
} 

# Group & summarize
NEI2 <- group_by(NEI,year)
# plot to screen
plot(summarize(NEI2,sum(Emissions)), xlab="Year",ylab= "tonnes (t)", main="Total PM25 emissions, all sources (tonnes)",pch=20)

# Create plot
png(file = "plot1.png",width = 480, height = 480)  ## Open PNG device
plot(summarize(NEI2,sum(Emissions)), xlab="Year",ylab= "tonnes (t)", main="Total PM25 emissions, all sources (tonnes)",pch=20)
dev.off()  ## Close the PNG file device
