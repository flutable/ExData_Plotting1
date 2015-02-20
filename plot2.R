#DS04 Exploratory Data Analysis Project 2 Plot2

#Q2 Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
#    A: Over that period, yes, though there was an increase in 2005.


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

# Group by years of interest
NEI2 <- group_by(NEI,year)

# Filter out Baltimore
NEI2 <- filter(NEI2,fips == "24510")

# Plot to screen
plot(summarize(NEI2,sum(Emissions)), xlab="Year",ylab= "tonnes (t)", main="Total PM25 emissions, all sources, Baltimore (tonnes)",pch=20)

# Plot to file
png(file = "plot2.png", width = 480, height = 480)  
plot(summarize(NEI2,sum(Emissions)), xlab="Year",ylab= "tonnes (t)", main="Total PM25 emissions, all sources, Baltimore (tonnes)",pch=20)
dev.off()  